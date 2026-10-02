import 'dart:math';

import 'package:flutter/material.dart';

import '../../config/api_constants.dart';

/// An icon that gently floats up and down with a sine-wave animation.
/// Used for empty-state illustrations.
class FloatingIcon extends StatefulWidget {
  const FloatingIcon({
    super.key,
    required this.icon,
    this.size = 48,
    this.color,
    this.amplitude = 6.0,
  });

  final IconData icon;
  final double size;
  final Color? color;
  final double amplitude;

  @override
  State<FloatingIcon> createState() => _FloatingIconState();
}

class _FloatingIconState extends State<FloatingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: TimingConstants.floatingCycleDurationMs,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Icon(widget.icon, size: widget.size, color: widget.color),
      builder: (context, child) {
        final offset = sin(_controller.value * 2 * pi) * widget.amplitude;
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
    );
  }
}
