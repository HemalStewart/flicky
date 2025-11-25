import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../theme/app_colors.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    super.key,
    required this.title,
    required this.url,
    this.poster,
  });

  final String title;
  final String url;
  final String? poster;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (!mounted) return;
        _controller?.setLooping(false);
        _controller?.play();
        setState(() => _ready = true);
      }).catchError((error) {
        debugPrint('Video init error: $error');
        if (!mounted) return;
        setState(() => _ready = false);
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: controller != null && controller.value.isInitialized
                ? _RotatedFullscreenVideo(controller: controller)
                : widget.poster != null
                    ? Transform.rotate(
                        angle: 1.5708,
                        child: Image.network(
                          widget.poster!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) =>
                              Container(color: Colors.black),
                        ),
                      )
                    : Container(color: Colors.black),
          ),
          if (!_ready)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (controller != null && controller.value.isInitialized)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                minimum: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: _Controls(controller: controller),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RotatedFullscreenVideo extends StatelessWidget {
  const _RotatedFullscreenVideo({required this.controller});
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    final size = controller.value.size;
    return Center(
      child: RotatedBox(
        quarterTurns: 1,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: size.height,
            height: size.width,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }
}

class _Controls extends StatefulWidget {
  const _Controls({required this.controller});
  final VideoPlayerController controller;

  @override
  State<_Controls> createState() => _ControlsState();
}

class _ControlsState extends State<_Controls> {
  double _position = 0;
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_sync);
  }

  void _sync() {
    final v = widget.controller.value;
    if (!mounted) return;
    setState(() {
      if (v.isInitialized && v.duration.inMilliseconds > 0) {
        _position =
            v.position.inMilliseconds / v.duration.inMilliseconds.toDouble();
      } else {
        _position = 0;
      }
      _muted = (v.volume == 0);
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_sync);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.controller.value;
    final playing = v.isPlaying;
    final duration = v.duration;
    final position = v.position;
    final hasDuration = v.isInitialized && duration.inMilliseconds > 0;

    String format(Duration d) {
      if (d.inMilliseconds <= 0) return '00:00';
      final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      final hours = d.inHours;
      if (hours > 0) {
        return '$hours:$minutes:$seconds';
      }
      return '$minutes:$seconds';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              playing ? widget.controller.pause() : widget.controller.play();
            },
            icon: Icon(
              playing ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 26,
            ),
          ),
          IconButton(
            onPressed: hasDuration
                ? () {
                    final target = position - const Duration(seconds: 10);
                    widget.controller.seekTo(
                      target < Duration.zero ? Duration.zero : target,
                    );
                  }
                : null,
            icon: const Icon(Icons.replay_10, color: Colors.white, size: 22),
          ),
          IconButton(
            onPressed: hasDuration
                ? () {
                    final target = position + const Duration(seconds: 10);
                    final capped = target > duration ? duration : target;
                    widget.controller.seekTo(capped);
                  }
                : null,
            icon: const Icon(Icons.forward_10, color: Colors.white, size: 22),
          ),
          IconButton(
            onPressed: () async {
              final newVol = _muted ? 1.0 : 0.0;
              await widget.controller.setVolume(newVol);
              setState(() => _muted = !_muted);
            },
            icon: Icon(
              _muted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
              size: 22,
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value: _position.clamp(0, 1),
                activeColor: AppColors.accent,
                inactiveColor: Colors.white24,
                onChanged: hasDuration
                    ? (value) {
                        final target = Duration(
                          milliseconds:
                              (duration.inMilliseconds * value).toInt(),
                        );
                        widget.controller.seekTo(target);
                      }
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${format(position)} / ${format(duration)}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
