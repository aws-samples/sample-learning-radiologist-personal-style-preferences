import 'package:flutter/material.dart';

import '../../config/api_constants.dart';

/// A generate/regenerate button that pulses with a glow effect
/// when no impression exists and the system is idle.
class PulsingGenerateButton extends StatefulWidget {
  const PulsingGenerateButton({
    super.key,
    required this.onPressed,
    required this.isGenerating,
    required this.isSaving,
    required this.hasImpression,
    required this.label,
  });

  final VoidCallback? onPressed;
  final bool isGenerating;
  final bool isSaving;
  final bool hasImpression;
  final String label;

  @override
  State<PulsingGenerateButton> createState() => _PulsingGenerateButtonState();
}

class _PulsingGenerateButtonState extends State<PulsingGenerateButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _shouldPulse =>
      !widget.hasImpression && !widget.isGenerating && !widget.isSaving;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: TimingConstants.pulsingCycleDurationMs,
      ),
    );
    if (_shouldPulse) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulsingGenerateButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldPulse && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!_shouldPulse && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glowOpacity = _shouldPulse ? _controller.value * 0.25 : 0.0;
        final blurRadius = _shouldPulse ? 12.0 + (_controller.value * 8.0) : 0.0;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: glowOpacity > 0
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: glowOpacity),
                      blurRadius: blurRadius,
                    ),
                  ]
                : null,
          ),
          child: child,
        );
      },
      child: Tooltip(
        message: widget.isGenerating
            ? 'Generation in progress...'
            : widget.isSaving
                ? 'Save in progress...'
                : 'Generate impression (Ctrl+G)',
        child: FilledButton.icon(
          onPressed: widget.isGenerating || widget.isSaving
              ? null
              : widget.onPressed,
          icon: widget.isGenerating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.auto_awesome),
          label: Text(widget.label),
        ),
      ),
    );
  }
}
