import 'package:flutter/material.dart';

import '../data/saved_repository.dart';
import '../data/tv_data.dart';
import '../models/media_item.dart';
import '../routes/fade_slide_route.dart';
import '../theme/app_colors.dart';
import '../widgets/tap_scale.dart';
import 'tv_season_page.dart';
import 'player_screen.dart';

class TvSeriesDetailPage extends StatefulWidget {
  const TvSeriesDetailPage({super.key, required this.item, this.heroTag});

  final MediaItem item;
  final String? heroTag;

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  double _userRating = 4.0;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  void _showRateSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Rate ${widget.item.title}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        _userRating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(5, (index) {
                      final val = index + 1;
                      return IconButton(
                        onPressed: () =>
                            setState(() => _userRating = val.toDouble()),
                        icon: Icon(
                          Icons.star,
                          color: _userRating >= val
                              ? AppColors.gold
                              : Colors.white24,
                          size: 30,
                        ),
                      );
                    }),
                  ),
                  Slider(
                    value: _userRating,
                    min: 1,
                    max: 5,
                    divisions: 8,
                    activeColor: AppColors.accent,
                    inactiveColor: Colors.white24,
                    onChanged: (v) => setState(() => _userRating = v),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset.clamp(0, 140);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final seasonList = seasonsFor(item);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Tv Series Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Transform.translate(
                offset: Offset(0, -_scrollOffset * 0.12),
                child: Hero(
                  tag: widget.heroTag ??
                      'trending-${item.imageUrl}-${item.title}',
                  child: _HeroPlayer(imageUrl: item.imageUrl),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: AppColors.gold),
                    const SizedBox(width: 6),
                    Text(
                      (item.rating ?? 4.5).toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _MetaRow(item: item),
              const SizedBox(height: 16),
              _ActionRow(item: item, onRate: _showRateSheet),
              const SizedBox(height: 18),
              Text(
                'All Series',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: seasonList.length,
                  separatorBuilder: (_, i) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final season = seasonList[index];
                    return TapScale(
                      onTap: () => Navigator.push(
                        context,
                        FadeSlideRoute(
                          page: TvSeasonPage(series: item, season: season),
                        ),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              season.image,
                              width: 90,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            season.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Cast',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: item.cast.isNotEmpty ? item.cast.length : 6,
                  separatorBuilder: (_, i) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final name = item.cast.isNotEmpty
                        ? item.cast[index]
                        : 'Sylvester Stallone';
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Description',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                item.description ??
                    '"Stallone" redirects here. For other people with this name, see Stallone (name). Sylvester Stallone Stallone in 2019 Special Ambassador to Hollywood Incumbent Assumed office January 20, 2025 Serving with Mel Gibson and Jon Voight',
                style: TextStyle(color: AppColors.muted, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroPlayer extends StatelessWidget {
  const _HeroPlayer({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 70,
            width: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black54,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.item});

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.white;
    final textColor = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Meta(
            icon: Icons.calendar_today,
            label: '18 Sep 1987',
            iconColor: iconColor,
            textColor: textColor,
          ),
          _Meta(
            icon: Icons.access_time,
            label: item.duration,
            iconColor: iconColor,
            textColor: textColor,
          ),
          _Meta(
            icon: Icons.grid_view,
            label: item.category,
            iconColor: iconColor,
            textColor: textColor,
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.item, required this.onRate});

  final MediaItem item;
  final VoidCallback onRate;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<MediaItem>>(
      valueListenable: SavedRepository.saved,
      builder: (context, savedList, _) {
        final saved = SavedRepository.isSaved(item);
        final onSurface = Theme.of(context).colorScheme.onSurface;
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: _ActionButton(
                icon: Icons.play_circle_outline,
                label: 'Watch Now',
                background: AppColors.accent,
                onTap: () {
                  final playUrl = item.videoUrl ?? item.trailerUrl;
                  if (playUrl == null) return;
                  Navigator.push(
                    context,
                    FadeSlideRoute(
                      page: PlayerScreen(
                        title: item.title,
                        url: playUrl,
                        poster: item.imageUrl,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: saved ? Icons.bookmark : Icons.bookmark_border,
                label: saved ? 'Saved' : 'Save',
                foreground: onSurface,
                onTap: () {
                  SavedRepository.toggle(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        SavedRepository.isSaved(item)
                            ? 'Added to saved'
                            : 'Removed from saved',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.star_border,
                label: 'Rate',
                foreground: onSurface,
                onTap: onRate,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.background,
    this.onTap,
    this.foreground,
  });

  final IconData icon;
  final String label;
  final Color? background;
  final VoidCallback? onTap;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final textColor = background != null
        ? Colors.white
        : foreground ?? Theme.of(context).colorScheme.onSurface;
    final iconColor = background != null ? Colors.white : textColor;
    return TapScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: background ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
