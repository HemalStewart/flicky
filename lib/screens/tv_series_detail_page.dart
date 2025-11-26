import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  VideoPlayerController? _controller;
  bool _ready = false;
  double _userRating = 4.0;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  static const _fallbackTrailer =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

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
    final trailer = widget.item.trailerUrl ?? _fallbackTrailer;
    _controller = VideoPlayerController.networkUrl(Uri.parse(trailer))
      ..initialize().then((_) {
        _controller?.setLooping(true);
        if (mounted) setState(() => _ready = true);
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _TrailerPlayer(
                      controller: _controller,
                      ready: _ready,
                      imageUrl: item.imageUrl,
                    ),
                  ),
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

class _TrailerPlayer extends StatefulWidget {
  const _TrailerPlayer({
    required this.controller,
    required this.ready,
    required this.imageUrl,
  });

  final VideoPlayerController? controller;
  final bool ready;
  final String imageUrl;

  @override
  State<_TrailerPlayer> createState() => _TrailerPlayerState();
}

class _TrailerPlayerState extends State<_TrailerPlayer> {
  bool _visible = true;
  Timer? _hideTimer;
  bool _played = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTick);
  }

  @override
  void didUpdateWidget(covariant _TrailerPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onTick);
      widget.controller?.addListener(_onTick);
    }
  }

  void _onTick() {
    if (!mounted) return;
    final playing = widget.controller?.value.isPlaying ?? false;
    if (playing) _scheduleHide();
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    if (widget.controller?.value.isPlaying != true) return;
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _visible = false);
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    widget.controller?.removeListener(_onTick);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final showVideo = _played &&
        widget.ready &&
        controller != null &&
        controller.value.isInitialized;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: GestureDetector(
            onTap: () {
              if (!_played &&
                  controller != null &&
                  controller.value.isInitialized) {
                setState(() {
                  _played = true;
                  _visible = true;
                });
                controller.play();
                _scheduleHide();
                return;
              }
              if (!showVideo) return;
              setState(() => _visible = !_visible);
              if (_visible) {
                _scheduleHide();
              } else {
                _hideTimer?.cancel();
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: showVideo
                      ? VideoPlayer(controller)
                      : Image.network(widget.imageUrl, fit: BoxFit.cover),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                if (!showVideo)
                  Container(
                    height: 74,
                    width: 74,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.55),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (controller == null) return;
                        if (!_played) setState(() => _played = true);
                        controller.play();
                        _scheduleHide();
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                  ),
                if (controller != null && showVideo)
                  Positioned(
                    child: ValueListenableBuilder<VideoPlayerValue>(
                      valueListenable: controller,
                      builder: (context, value, _) {
                        final duration = value.duration;
                        final position = value.position;
                        final hasDuration =
                            value.isInitialized && duration.inMilliseconds > 0;
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _visible ? 1 : 0,
                          child: IgnorePointer(
                            ignoring: !_visible,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: hasDuration
                                      ? () {
                                          final target =
                                              position - const Duration(seconds: 10);
                                          controller.seekTo(
                                            target < Duration.zero
                                                ? Duration.zero
                                                : target,
                                          );
                                          setState(() => _visible = true);
                                          _scheduleHide();
                                        }
                                      : null,
                                  icon: const Icon(
                                    Icons.replay_10,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  onPressed: () {
                                    if (!_played) {
                                      setState(() {
                                        _played = true;
                                        _visible = true;
                                      });
                                      controller.play();
                                    } else {
                                      value.isPlaying
                                          ? controller.pause()
                                          : controller.play();
                                    }
                                    _scheduleHide();
                                  },
                                  icon: Icon(
                                    value.isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_fill,
                                    color: Colors.white,
                                    size: 68,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  onPressed: hasDuration
                                      ? () {
                                          final target =
                                              position + const Duration(seconds: 10);
                                          controller.seekTo(
                                            target > duration ? duration : target,
                                          );
                                          setState(() => _visible = true);
                                          _scheduleHide();
                                        }
                                      : null,
                                  icon: const Icon(
                                    Icons.forward_10,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                if (showVideo)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _InlineControlsOverlay(
                      controller: controller,
                      visible: _visible,
                      onInteract: _scheduleHide,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InlineControlsOverlay extends StatelessWidget {
  const _InlineControlsOverlay({
    required this.controller,
    required this.visible,
    required this.onInteract,
  });

  final VideoPlayerController controller;
  final bool visible;
  final VoidCallback onInteract;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final duration = value.duration;
        final position = value.position;
        final hasDuration = duration.inMilliseconds > 0;
        final progress = hasDuration
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0;

        String fmt(Duration d) {
          if (d.inMilliseconds <= 0) return '00:00';
          final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
          final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
          final h = d.inHours;
          return h > 0 ? '$h:$m:$s' : '$m:$s';
        }

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: visible ? 1 : 0,
          child: IgnorePointer(
            ignoring: !visible,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 36, 12, 14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          onInteract();
                          value.isPlaying
                              ? controller.pause()
                              : controller.play();
                        },
                        icon: Icon(
                          value.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          onInteract();
                          final muted = value.volume == 0;
                          await controller.setVolume(muted ? 1.0 : 0.0);
                        },
                        icon: Icon(
                          value.volume == 0
                              ? Icons.volume_off
                              : Icons.volume_up,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 7),
                          ),
                          child: Slider(
                            value: progress.clamp(0, 1),
                            activeColor: AppColors.accent,
                            inactiveColor: Colors.white24,
                            onChanged: hasDuration
                                ? (v) {
                                    onInteract();
                                    final target = Duration(
                                      milliseconds:
                                          (duration.inMilliseconds * v).toInt(),
                                    );
                                    controller.seekTo(target);
                                  }
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${fmt(position)} / ${fmt(duration)}',
                        style:
                            const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
