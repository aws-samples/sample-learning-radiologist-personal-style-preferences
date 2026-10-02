import 'package:flutter/material.dart';

import '../../models/user_settings.dart';
import 'model_picker.dart';

/// Card for selecting models for each agent
class ModelSelectionCard extends StatelessWidget {
  const ModelSelectionCard({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final UserSettings settings;
  final ValueChanged<ModelSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ModelPicker(
              label: 'Base Impression',
              description: 'Initial impression generation from findings',
              value: settings.modelSettings.baseImpression,
              onChanged: (value) => onChanged(
                settings.modelSettings.copyWith(baseImpression: value),
              ),
            ),
            const Divider(height: 24),
            ModelPicker(
              label: 'Style Refinement',
              description: 'Apply learned preferences to base impression',
              value: settings.modelSettings.styleRefinement,
              onChanged: (value) => onChanged(
                settings.modelSettings.copyWith(styleRefinement: value),
              ),
            ),
            const Divider(height: 24),
            ModelPicker(
              label: 'Preference Inference',
              description: 'Extract new preferences from your edits',
              value: settings.modelSettings.preferenceInference,
              onChanged: (value) => onChanged(
                settings.modelSettings.copyWith(preferenceInference: value),
              ),
            ),
            const Divider(height: 24),
            ModelPicker(
              label: 'Preference Validator',
              description: 'Validate preferences are stylistic-only',
              value: settings.modelSettings.preferenceValidator,
              onChanged: (value) => onChanged(
                settings.modelSettings.copyWith(preferenceValidator: value),
              ),
            ),
            const Divider(height: 24),
            ModelPicker(
              label: 'Edit Validator',
              description: 'Validate direct preference edits',
              value: settings.modelSettings.preferenceEditValidator,
              onChanged: (value) => onChanged(
                settings.modelSettings.copyWith(preferenceEditValidator: value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
