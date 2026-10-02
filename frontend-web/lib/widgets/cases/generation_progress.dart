import 'package:flutter/material.dart';

import '../../services/api_service.dart';

/// Progress card for generation operation
class GenerationProgressCard extends StatelessWidget {
  const GenerationProgressCard({super.key, required this.phase});

  final GenerationPhase phase;

  @override
  Widget build(BuildContext context) {
    return _ProgressCard(
      title: 'Generating Impression',
      phases: GenerationPhase.values,
      currentPhase: phase,
      phaseLabels: const {
        GenerationPhase.starting: 'Starting...',
        GenerationPhase.retrieving: 'Retrieving preferences...',
        GenerationPhase.generating: 'Generating base impression...',
        GenerationPhase.refining: 'Applying style refinements...',
        GenerationPhase.finishing: 'Finishing...',
      },
    );
  }
}

/// Progress card for save operation
class SaveProgressCard extends StatelessWidget {
  const SaveProgressCard({super.key, required this.phase});

  final SavePhase phase;

  @override
  Widget build(BuildContext context) {
    return _ProgressCard(
      title: 'Saving Edit',
      phases: SavePhase.values,
      currentPhase: phase,
      phaseLabels: const {
        SavePhase.saving: 'Saving changes...',
        SavePhase.analyzing: 'Analyzing edit...',
        SavePhase.extracting: 'Extracting preferences...',
        SavePhase.validating: 'Validating safety...',
        SavePhase.finishing: 'Finishing...',
      },
    );
  }
}

class _ProgressCard<T extends Enum> extends StatelessWidget {
  const _ProgressCard({
    required this.title,
    required this.phases,
    required this.currentPhase,
    required this.phaseLabels,
  });

  final String title;
  final List<T> phases;
  final T currentPhase;
  final Map<T, String> phaseLabels;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentIndex = phases.indexOf(currentPhase);

    return Card(
      color: colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Phase steps
            ...phases.asMap().entries.map((entry) {
              final index = entry.key;
              final phase = entry.value;
              final isComplete = index < currentIndex;
              final isCurrent = index == currentIndex;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    if (isComplete)
                      Icon(
                        Icons.check_circle,
                        size: 20,
                        color: colorScheme.primary,
                      )
                    else if (isCurrent)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      )
                    else
                      Icon(
                        Icons.circle_outlined,
                        size: 20,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                    const SizedBox(width: 12),
                    Text(
                      phaseLabels[phase] ?? phase.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isCurrent
                                ? colorScheme.onSurface
                                : isComplete
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.5),
                            fontWeight:
                                isCurrent ? FontWeight.w600 : FontWeight.normal,
                          ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
