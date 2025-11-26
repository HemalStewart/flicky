import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/media_item.dart';

class ContentApi {
  ContentApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  // Legacy backend: uses funName-based GET endpoints.
  Future<HomePayload> fetchHome() async {
    final movies = await _fetchMoviesLegacy(funName: 'getAllNewPosters');
    final series = await _fetchSeriesLegacy(funName: 'getAllNewArrivalSeries');
    final trending = await _fetchMoviesLegacy(funName: 'getMostViewMovie');
    final trendingList = trending.isNotEmpty ? trending : movies;
    return HomePayload(trending: trendingList, movies: movies, series: series);
  }

  Future<List<MediaItem>> search(String query) async {
    if (query.trim().isEmpty) return const [];
    final res = await _callLegacy({
      'funName': 'getAllSearchedContent',
      'search': query.trim(),
    });
    final body = _decodeRelaxed(res);
    final data = body['response'] ?? body['data'] ?? body;
    if (data is! List) return const [];
    return data.whereType<Map<String, dynamic>>().map(_mapPosterOnly).toList();
  }

  Future<List<MediaItem>> movies({int limit = 50}) =>
      _fetchMoviesLegacy(funName: 'getAllNewPosters');

  Future<List<MediaItem>> series({int limit = 50}) =>
      _fetchSeriesLegacy(funName: 'getAllNewArrivalSeries');

  Future<List<MediaItem>> _fetchMoviesLegacy({required String funName}) async {
    final res = await _callLegacy({'funName': funName});
    final body = _decodeRelaxed(res);
    final data = body['response'] ?? body['data'] ?? body;
    return _mapMovieListLegacy(data);
  }

  Future<List<MediaItem>> _fetchSeriesLegacy({required String funName}) async {
    final res = await _callLegacy({'funName': funName});
    final body = _decodeRelaxed(res);
    final data = body['response'] ?? body['data'] ?? body;
    return _mapSeriesListLegacy(data);
  }

  Future<List<MediaItem>> _mapMovieListLegacy(dynamic data) async {
    if (data is! List) return const [];
    final basePoster =
        'https://phpstack-1483171-5674853.cloudwaysapps.com/flickyapi/resources/images/movie/';
    final items = data.whereType<Map<String, dynamic>>().map((json) {
      final poster = json['poster'] as String? ?? '';
      final normalizedPoster =
          poster.contains('http') ? poster : basePoster + poster.split('/').last;
      final trailer = json['trailer_url'] as String?;
      final video = json['url'] as String?;
      return MediaItem(
        id: (json['id'] as num?)?.toInt(),
        title: (json['title'] ?? '') as String,
        year: ((json['release_year'] ?? '')).toString(),
        duration: (json['duration'] ?? '') as String,
        category: (json['genre'] ?? 'Movie') as String,
        imageUrl: normalizedPoster,
        rating: (json['rating'] as num?)?.toDouble(),
        description: (json['synopsis'] ?? '') as String,
        tags: _splitTags(json['genre']),
        trailerUrl: trailer,
        videoUrl: video,
        isSeries: false,
      );
    }).toList();
    return _presignMediaList(items);
  }

  Future<List<MediaItem>> _mapSeriesListLegacy(dynamic data) async {
    if (data is! List) return const [];
    final basePoster =
        'https://phpstack-1483171-5674853.cloudwaysapps.com/flickyapi/resources/images/series/';
    final items = data.whereType<Map<String, dynamic>>().map((json) {
      final poster = json['poster'] as String? ?? '';
      final normalizedPoster =
          poster.contains('http') ? poster : basePoster + poster.split('/').last;
      return MediaItem(
        id: (json['id'] as num?)?.toInt(),
        title: (json['title'] ?? '') as String,
        year: ((json['release_year'] ?? '')).toString(),
        duration: (json['duration'] ?? 'Seasons') as String,
        category: (json['genre'] ?? 'Series') as String,
        imageUrl: normalizedPoster,
        rating: (json['rating'] as num?)?.toDouble(),
        description: (json['synopsis'] ?? '') as String,
        tags: _splitTags(json['genre']),
        trailerUrl: json['trailer_url'] as String?,
        videoUrl: json['url'] as String?,
        isSeries: true,
      );
    }).toList();
    return _presignMediaList(items);
  }

  MediaItem _mapPosterOnly(Map<String, dynamic> json) {
    final id = (json['id'] as num?)?.toInt();
    final poster = json['poster'] as String? ?? '';
    final contentType = (json['content_type'] ?? 'movie') as String;
    final base = contentType == 'series'
        ? 'https://phpstack-1483171-5674853.cloudwaysapps.com/flickyapi/resources/images/series/'
        : 'https://phpstack-1483171-5674853.cloudwaysapps.com/flickyapi/resources/images/movie/';
    final normalizedPoster =
        poster.contains('http') ? poster : base + poster.split('/').last;
    return MediaItem(
      id: id,
      title: 'Item ${id ?? ''}',
      year: '',
      duration: '',
      category: contentType == 'series' ? 'Series' : 'Movie',
      imageUrl: normalizedPoster,
      isSeries: contentType == 'series',
    );
  }

  List<String> _splitTags(dynamic genre) {
    if (genre is String) {
      return genre
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
    }
    return const [];
  }

  Future<http.Response> _callLegacy(Map<String, String> params) async {
    final uri = Uri.parse(AppConfig.legacyBase).replace(queryParameters: params);
    return _client.get(uri).timeout(const Duration(seconds: 10));
  }

  Map<String, dynamic> _decodeRelaxed(http.Response response) {
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      return {'data': response.body};
    }
  }

  Future<List<MediaItem>> _presignMediaList(List<MediaItem> items) async {
    final futures = items.map(_presignMediaItem).toList();
    return Future.wait(futures);
  }

  Future<MediaItem> _presignMediaItem(MediaItem item) async {
    final poster = await _presignIfPrivate(item.imageUrl);

    String? trailer = item.trailerUrl;
    String? video = item.videoUrl;

    if (item.id != null) {
      trailer = await _legacySignedTrailer(item.id!, item.isSeries) ??
          await _presignIfPrivate(item.trailerUrl);
      video = await _legacySignedVideo(item.id!, item.isSeries) ??
          await _presignIfPrivate(item.videoUrl);
    } else {
      trailer = await _presignIfPrivate(item.trailerUrl);
      video = await _presignIfPrivate(item.videoUrl);
    }

    return item.copyWith(
      imageUrl: poster ?? item.imageUrl,
      trailerUrl: trailer ?? item.trailerUrl,
      videoUrl: video ?? item.videoUrl,
    );
  }

  Future<String?> _presignIfPrivate(String? url) async {
    if (url == null || url.isEmpty) return null;
    if (!url.contains('digitaloceanspaces.com')) return url;
    final uri = Uri.parse(url);
    final key = uri.path.replaceFirst(RegExp(r'^/+'), '');
    final presignCandidates = <Uri>[
      Uri.parse('${AppConfig.presignBase}/media/presign?key=$key'),
      Uri.parse('${AppConfig.apiBase}/media/presign?key=$key'),
      Uri.parse('${AppConfig.apiBase}/api/media/presign?key=$key'),
      Uri.parse('${AppConfig.apiBase}/index.php/api/media/presign?key=$key'),
    ];
    for (final endpoint in presignCandidates) {
      try {
        final res =
            await _client.get(endpoint).timeout(const Duration(seconds: 10));
        if (res.statusCode == 200) {
          final body = _decodeRelaxed(res);
          final signed = body['url'] as String?;
          if (signed != null && signed.isNotEmpty) return signed;
        }
      } catch (_) {
        // try next candidate
      }
    }
    return url;
  }

  Future<String?> _legacySignedTrailer(int id, bool isSeries) async {
    final params = isSeries
        ? {'funName': 'getSeriesUrl', 'series_id': '$id'}
        : {'funName': 'getTrailerUrl', 'id': '$id'};
    return _legacySignedUrl(params);
  }

  Future<String?> _legacySignedVideo(int id, bool isSeries) async {
    final params = isSeries
        ? {
            'funName': 'getFullSeriesUrl',
            'series_id': '$id',
            'season_number': '1',
            'episode_number': '1',
          }
        : {'funName': 'getFullMovieUrl', 'id': '$id'};
    return _legacySignedUrl(params);
  }

  Future<String?> _legacySignedUrl(Map<String, String> params) async {
    final uri = Uri.parse(AppConfig.legacyBase).replace(queryParameters: params);
    try {
      final res = await _client.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final body = _decodeRelaxed(res);
        return _pickUrl(body);
      }
    } catch (_) {
      // ignore
    }
    return null;
  }

  String? _pickUrl(dynamic body) {
    if (body is String && body.startsWith('http')) return body;
    if (body is Map<String, dynamic>) {
      final fromUrl = body['url'] as String?;
      if (fromUrl != null && fromUrl.startsWith('http')) return fromUrl;
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        final nested = data['url'] as String?;
        if (nested != null && nested.startsWith('http')) return nested;
      }
      final response = body['response'];
      if (response is Map<String, dynamic>) {
        final nested = response['url'] as String?;
        if (nested != null && nested.startsWith('http')) return nested;
      }
      if (response is String && response.startsWith('http')) return response;
    }
    return null;
  }
}

class HomePayload {
  HomePayload({
    required this.trending,
    required this.movies,
    required this.series,
  });

  final List<MediaItem> trending;
  final List<MediaItem> movies;
  final List<MediaItem> series;
}

class ContentApiException implements Exception {
  ContentApiException(this.message);
  final String message;

  @override
  String toString() => message;
}
