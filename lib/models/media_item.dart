class MediaItem {
  const MediaItem({
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
}
