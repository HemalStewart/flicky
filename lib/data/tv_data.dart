import '../models/media_item.dart';

class SeasonInfo {
  SeasonInfo({required this.title, required this.image});
  final String title;
  final String image;
}

class EpisodeInfo {
  EpisodeInfo({
    required this.title,
    required this.description,
    required this.duration,
    required this.image,
  });

  final String title;
  final String description;
  final String duration;
  final String image;
}

final defaultSeasonImage =
    'https://image.tmdb.org/t/p/w500/od22ftNnyag0TTxcnJhlsu3aLoU.jpg';

List<SeasonInfo> seasonsFor(MediaItem item) {
  return List.generate(
    4,
    (i) => SeasonInfo(title: 'Season ${i + 1}', image: item.imageUrl),
  );
}

List<EpisodeInfo> episodesForSeason(SeasonInfo season) {
  return List.generate(
    6,
    (i) => EpisodeInfo(
      title: '${season.title} Episode ${i + 1}',
      description: 'The secret',
      duration: '${30 + i * 3}m',
      image: season.image,
    ),
  );
}
