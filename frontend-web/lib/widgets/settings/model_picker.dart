import 'package:flutter/material.dart';

import '../../models/user_settings.dart';

/// Dropdown picker for selecting a Claude model
class ModelPicker extends StatelessWidget {
  const ModelPicker({
    super.key,
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String description;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Normalize the value from API format (e.g., "claude-sonnet-4.5") to short key ("sonnet")
    final normalizedValue = AvailableModels.normalizeModelKey(value);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 180,
          child: InputDecorator(
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: normalizedValue,
                isExpanded: true,
                isDense: true,
                items: AvailableModels.models.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Row(
                      children: [
                        Icon(
                          _getModelIcon(entry.key),
                          size: 16,
                          color: _getModelColor(entry.key),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getShortName(entry.key),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    onChanged(newValue);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getModelIcon(String modelKey) {
    switch (modelKey) {
      case 'opus':
        return Icons.stars;
      case 'sonnet':
        return Icons.auto_awesome;
      case 'haiku':
        return Icons.bolt;
      default:
        return Icons.smart_toy;
    }
  }

  Color _getModelColor(String modelKey) {
    switch (modelKey) {
      case 'opus':
        return Colors.purple;
      case 'sonnet':
        return Colors.blue;
      case 'haiku':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getShortName(String modelKey) {
    switch (modelKey) {
      case 'opus':
        return 'Opus 4.8';
      case 'sonnet':
        return 'Sonnet 4.6';
      case 'haiku':
        return 'Haiku 4.5';
      default:
        return modelKey;
    }
  }
}
