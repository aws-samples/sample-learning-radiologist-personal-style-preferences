import 'package:flutter/material.dart';

import '../../models/user_settings.dart';

/// Card for toggling clinical interpretation mode
class ClinicalInterpretationCard extends StatelessWidget {
  const ClinicalInterpretationCard({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final UserSettings settings;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enable Clinical Interpretation',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        settings.clinicalInterpretation
                            ? 'Allows standard radiological inferences'
                            : 'Strictly uses terms from findings only',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: settings.clinicalInterpretation,
                  onChanged: onChanged,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Example comparison
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Example:',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Strict Grounding',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: !settings.clinicalInterpretation
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                    fontWeight: !settings.clinicalInterpretation
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '"No consolidation, pleural effusion, or pneumothorax."',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Clinical Interpretation',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: settings.clinicalInterpretation
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                    fontWeight: settings.clinicalInterpretation
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '"No consolidation to suggest pneumonia. No pleural effusion or pneumothorax."',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
