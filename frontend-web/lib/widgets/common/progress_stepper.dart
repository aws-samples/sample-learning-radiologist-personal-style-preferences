import 'package:flutter/material.dart';

import '../../config/api_constants.dart';

/// A step in the progress stepper
class ProgressStep<T extends Enum> {
  const ProgressStep({required this.phase, required this.label});

  final T phase;
  final String label;
}

/// Generic progress stepper widget that shows completion status for multiple steps
class ProgressStepper<T extends Enum> extends StatelessWidget {
  const ProgressStepper({
    super.key,
    required this.title,
    required this.currentPhase,
    required this.steps,
  });

  final String title;
  final T currentPhase;
  final List<ProgressStep<T>> steps;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...steps.map((step) {
            final isComplete = currentPhase.index > step.phase.index;
            final isCurrent = currentPhase == step.phase;
            final stepState = isComplete ? 'complete' : (isCurrent ? 'current' : 'future');
            final iconData = isComplete
                ? Icons.check_circle
                : (isCurrent ? Icons.radio_button_checked : Icons.radio_button_unchecked);
            final iconColor = isComplete
                ? Colors.green
                : (isCurrent ? colorScheme.primary : colorScheme.onSurfaceVariant);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: TimingConstants.mediumTransitionMs),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      iconData,
                      key: ValueKey('$stepState-${step.phase.index}'),
                      size: 18,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: TimingConstants.mediumTransitionMs),
                      style: TextStyle(
                        color: isCurrent || isComplete
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                      ),
                      child: Text(step.label),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
