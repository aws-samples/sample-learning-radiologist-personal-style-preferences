import 'package:flutter/material.dart';

import '../../config/api_constants.dart';
import '../../config/app_theme.dart';

/// Section card for displaying/editing findings
class FindingsSection extends StatelessWidget {
  const FindingsSection({
    super.key,
    required this.controller,
    required this.isEditing,
    this.isSaving = false,
    required this.onEditToggle,
    required this.onSave,
    required this.onCancel,
  });

  final TextEditingController controller;
  final bool isEditing;
  final bool isSaving;
  final VoidCallback onEditToggle;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textLength = controller.text.length;
    final isNearLimit = textLength > ValidationConstants.findingsWarningThreshold;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: AppTheme.sectionHeaderDecoration(colorScheme),
            child: Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Findings',
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isEditing) ...[
                  TextButton(
                    onPressed: isSaving ? null : onCancel,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    onPressed: isSaving ? null : onSave,
                    child: isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
                ] else
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    tooltip: 'Edit findings',
                    onPressed: onEditToggle,
                  ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isEditing)
                  TextField(
                    controller: controller,
                    maxLines: 10,
                    style: Theme.of(context).extension<ClinicalTextTheme>()?.editorStyle,
                    decoration: InputDecoration(
                      hintText: 'Enter findings...',
                      border: const OutlineInputBorder(),
                      counterText:
                          '$textLength / ${ValidationConstants.maxFindingsLength}',
                      counterStyle: TextStyle(
                        color: isNearLimit ? Colors.orange : null,
                      ),
                    ),
                    maxLength: ValidationConstants.maxFindingsLength,
                  )
                else
                  SelectableText(
                    controller.text,
                    style: Theme.of(context).extension<ClinicalTextTheme>()?.bodyStyle
                        ?? Theme.of(context).textTheme.bodyMedium,
                  ),
                if (isNearLimit && isEditing)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber,
                          size: 16,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Approaching character limit',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
