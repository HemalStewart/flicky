class MediaItem {
  const MediaItem({
    this.id,
    required this.title,
    required this.year,
    required this.duration,
    required this.category,
    required this.imageUrl,
    this.rating,
    this.description,
    this.cast = const [],
    this.director,
    this.tags = const [],
    this.trailerUrl,
    this.videoUrl,
    this.isSeries = false,
  });

  final int? id;
  final String title;
  final String year;
  final String duration;
  final String category;
  final String imageUrl;
  final double? rating;
  final String? description;
  final List<String> cast;
  final String? director;
  final List<String> tags;
  final String? trailerUrl;
  final String? videoUrl;
  final bool isSeries;

  MediaItem copyWith({
    int? id,
    String? title,
    String? year,
    String? duration,
    String? category,
    String? imageUrl,
    double? rating,
    String? description,
    List<String>? cast,
    String? director,
    List<String>? tags,
    String? trailerUrl,
    String? videoUrl,
    bool? isSeries,
  }) {
    return MediaItem(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      cast: cast ?? this.cast,
      director: director ?? this.director,
      tags: tags ?? this.tags,
      trailerUrl: trailerUrl ?? this.trailerUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      isSeries: isSeries ?? this.isSeries,
    );
  }

  factory MediaItem.fromMovieJson(Map<String, dynamic> json) {
    final genre = (json['genre'] ?? '') as String;
    final tags = genre.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
    final castList = (json['cast'] as List?)
            ?.map((e) => (e is Map<String, dynamic>) ? (e['name'] ?? '') : '')
            .whereType<String>()
            .where((e) => e.isNotEmpty)
            .toList() ??
        const [];
    final directors = (json['directors'] as List?)
            ?.map((e) => (e is Map<String, dynamic>) ? (e['name'] ?? '') : (e?.toString() ?? ''))
            .where((e) => e.isNotEmpty)
            .toList() ??
        const [];

    return MediaItem(
      id: (json['id'] as num?)?.toInt(),
      title: (json['title'] ?? '') as String,
      year: ((json['year'] ?? json['release_year'] ?? '')).toString(),
      duration: (json['duration'] ?? '') as String,
      category: genre.isNotEmpty ? genre : 'Unknown',
      imageUrl: (json['poster'] ?? json['image'] ?? '') as String,
      rating: (json['rating'] as num?)?.toDouble(),
      description: (json['description'] ?? json['synopsis'] ?? '') as String,
      cast: castList,
      director: directors.isNotEmpty ? directors.first : null,
      tags: tags,
      trailerUrl: (json['trailer_url'] ?? json['trailerUrl'] ?? json['trailer']) as String?,
      videoUrl: (json['video_url'] ?? json['url']) as String?,
      isSeries: false,
    );
  }

  factory MediaItem.fromSeriesJson(Map<String, dynamic> json) {
    final genre = (json['genre'] ?? '') as String;
    final tags = genre.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
    return MediaItem(
      id: (json['id'] as num?)?.toInt(),
      title: (json['title'] ?? '') as String,
      year: ((json['release_year'] ?? json['year'] ?? '')).toString(),
      duration: (json['duration'] ?? 'Seasons') as String,
      category: genre.isNotEmpty ? genre : 'Series',
      imageUrl: (json['poster'] ?? json['image'] ?? '') as String,
      rating: (json['rating'] as num?)?.toDouble(),
      description: (json['description'] ?? json['synopsis'] ?? '') as String,
      tags: tags,
      trailerUrl: (json['trailer_url'] ?? json['trailerUrl']) as String?,
      videoUrl: (json['video_url'] ?? json['url']) as String?,
      isSeries: true,
    );
  }
}
