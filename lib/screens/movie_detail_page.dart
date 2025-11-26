import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../data/saved_repository.dart';
import '../models/media_item.dart';
import '../theme/app_colors.dart';
import '../widgets/tap_scale.dart';
import '../routes/fade_slide_route.dart';
import 'player_screen.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.item, this.heroTag});

  final MediaItem item;
  final String? heroTag;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  VideoPlayerController? _controller;
  bool _isReady = false;
  double _userRating = 4.0;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  static const _fallbackTrailer =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

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
        if (mounted) setState(() => _isReady = true);
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showRateSheet(BuildContext context) {
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
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(5, (index) {
                      final starValue = index + 1;
                      return IconButton(
                        onPressed: () =>
                            setState(() => _userRating = starValue.toDouble()),
                        icon: Icon(
                          Icons.star,
                          color: _userRating >= starValue
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
                    onChanged: (value) => setState(() => _userRating = value),
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
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
  Widget build(BuildContext context) {
    final item = widget.item;

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
                    'Movie Details',
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
                  tag:
                      widget.heroTag ?? 'poster-${item.imageUrl}-${item.title}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _TrailerPlayer(
                      controller: _controller,
                      ready: _isReady,
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
              Row(
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
                      icon: SavedRepository.isSaved(item)
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      label: SavedRepository.isSaved(item) ? 'Saved' : 'Save',
                      onTap: () {
                        SavedRepository.toggle(item);
                        setState(() {});
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
                      onTap: () => _showRateSheet(context),
                    ),
                  ),
                ],
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
              const SizedBox(height: 18),
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
              const SizedBox(height: 18),
              if (item.tags.isNotEmpty) ...[
                Text(
                  'Genres',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: item.tags
                      .map(
                        (t) => _Chip(
                          label: t,
                          color: const Color(0xFF252831),
                          textColor: Colors.white,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 18),
              ],
              if (item.director != null) ...[
                Text(
                  'Director',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.director!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
              ],
              Text(
                'More Like This',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  separatorBuilder: (_, i) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 120,
                        color: Theme.of(context).cardColor,
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Theme.of(context).cardColor),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
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
          _Meta(icon: Icons.calendar_today, label: item.year),
          _Meta(icon: Icons.access_time, label: item.duration),
          _Meta(icon: Icons.grid_view, label: item.category),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.white;
    final textColor = Theme.of(context).colorScheme.onSurface;
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.background,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final textColor = background != null ? Colors.white : onSurface;
    final iconColor = background != null ? Colors.white : onSurface;
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

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    this.color = const Color(0xFF1F2430),
    this.textColor = Colors.white,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
      ),
    );
  }
}
