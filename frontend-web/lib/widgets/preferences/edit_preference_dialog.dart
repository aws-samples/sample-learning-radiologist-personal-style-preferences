import 'package:flutter/material.dart';

import '../../config/api_constants.dart';
import '../../models/preference.dart';
import 'category_badge.dart';

/// Dialog for editing preference text
class EditPreferenceDialog extends StatefulWidget {
  const EditPreferenceDialog({
    super.key,
    required this.preference,
    required this.onSave,
  });

  final Preference preference;
  final Future<String?> Function(String) onSave;

  @override
  State<EditPreferenceDialog> createState() => _EditPreferenceDialogState();
}

class _EditPreferenceDialogState extends State<EditPreferenceDialog> {
  late TextEditingController _controller;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.preference.preferenceText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final error = await widget.onSave(_controller.text);

    if (error != null) {
      setState(() {
        _errorMessage = error;
        _isSaving = false;
      });
    } else {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pref = widget.preference;
    final hasChanges = _controller.text != pref.preferenceText;
    final canSave = hasChanges && _controller.text.isNotEmpty && !_isSaving;

    return AlertDialog(
      title: Row(
        children: [
          const Expanded(
            child: Text('Edit Preference'),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category badge
            if (pref.category != null) ...[
              CategoryBadge(category: pref.category!),
              const SizedBox(height: 16),
            ],
            // Text field
            TextField(
              controller: _controller,
              maxLines: 4,
              maxLength: ValidationConstants.maxPreferenceLength,
              enabled: !_isSaving,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Enter preference text...',
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              onChanged: (_) => setState(() {}),
            ),
            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: colorScheme.onErrorContainer,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Info text
            const SizedBox(height: 12),
            Text(
              'Note: Only stylistic edits are allowed. Content-adding changes '
              '(e.g., adding diagnoses or treatments) will be rejected.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: canSave ? _saveChanges : null,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save Changes'),
        ),
      ],
    );
  }
}
