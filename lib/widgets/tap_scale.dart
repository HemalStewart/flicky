import 'package:flutter/material.dart';

class TapScale extends StatefulWidget {
  const TapScale({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.97,
    this.duration = const Duration(milliseconds: 120),
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  double _current = 1;

  void _down(TapDownDetails _) {
    setState(() => _current = widget.scale);
  }

  void _end([TapUpDetails? _]) {
    setState(() => _current = 1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _down,
      onTapUp: _end,
      onTapCancel: _end,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _current,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
