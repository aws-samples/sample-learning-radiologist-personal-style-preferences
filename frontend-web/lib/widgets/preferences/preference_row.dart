import 'package:flutter/material.dart';

import '../../config/api_constants.dart';
import '../../config/app_theme.dart';
import '../../models/preference.dart';
import '../../utils/formatters.dart';
import 'category_badge.dart';
import 'confidence_badge.dart';
import 'edit_preference_dialog.dart';
import 'traceability_section.dart';

/// Card row for displaying a learned preference
class PreferenceRow extends StatefulWidget {
  const PreferenceRow({
    super.key,
    required this.preference,
    this.onDelete,
    this.onEdit,
  });

  final Preference preference;
  final VoidCallback? onDelete;
  final Future<String?> Function(String)? onEdit;

  @override
  State<PreferenceRow> createState() => _PreferenceRowState();
}

class _PreferenceRowState extends State<PreferenceRow> {
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pref = widget.preference;
    final categoryColor = Theme.of(context).extension<CategoryColorsTheme>()!.getColor(pref.category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _isHovered
                ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? colorScheme.outlineVariant
                  : colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: _isHovered ? 0.1 : 0.05),
                blurRadius: _isHovered ? 10 : 6,
                offset: Offset(0, _isHovered ? 3 : 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main content row
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    children: [
                      // Category color bar
                      Container(
                        width: 4,
                        height: 80,
                        decoration: BoxDecoration(
                          color: categoryColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                      ),
                      // Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header row
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (pref.category != null)
                                        CategoryBadge(category: pref.category!),
                                      if (pref.confidence != null) ...[
                                        const SizedBox(width: 8),
                                        ConfidenceBadge(confidence: pref.confidence!),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    formatTimestamp(pref.timestamp),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Preference text
                              Text(
                                pref.preferenceText,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              // User edit indicator
                              if (pref.userEditCount != null &&
                                  pref.userEditCount! > 0) ...[
                                const SizedBox(height: 8),
                                Builder(builder: (context) {
                                  final cs = Theme.of(context).colorScheme;
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cs.tertiaryContainer,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 14,
                                          color: cs.onTertiaryContainer,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Edited ${pref.userEditCount} time${pref.userEditCount! > 1 ? 's' : ''}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: cs.onTertiaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ],
                          ),
                        ),
                      ),
                      // Actions
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isExpanded ? Icons.expand_less : Icons.expand_more,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            if (widget.onEdit != null)
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                tooltip: 'Edit preference',
                                onPressed: () => _showEditDialog(context),
                              ),
                            if (widget.onDelete != null)
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20),
                                tooltip: 'Delete preference',
                                onPressed: () => _showDeleteConfirmation(context),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Expanded traceability section
              AnimatedSize(
                duration: const Duration(milliseconds: TimingConstants.standardTransitionMs),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: _isExpanded
                    ? _buildTraceability(context)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTraceability(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pref = widget.preference;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Inference explanation
          if (pref.inferenceExplanation != null) ...[
            TraceabilitySection(
              icon: Icons.psychology,
              iconColor: Colors.blue,
              title: 'How this was learned',
              content: pref.inferenceExplanation!,
            ),
            const SizedBox(height: 12),
          ],
          // Original impression
          if (pref.originalImpression != null) ...[
            TraceabilitySection(
              icon: Icons.format_quote,
              iconColor: Colors.grey,
              title: 'Original Impression',
              content: pref.originalImpression!,
            ),
            const SizedBox(height: 12),
          ],
          // Edited impression
          if (pref.editedImpression != null) ...[
            TraceabilitySection(
              icon: Icons.edit_note,
              iconColor: Colors.orange,
              title: 'Your Edit',
              content: pref.editedImpression!,
            ),
            const SizedBox(height: 12),
          ],
          // Source case
          Row(
            children: [
              Icon(
                Icons.folder_outlined,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Source: Case ${pref.sourceCaseId}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              if (pref.inferenceModel != null) ...[
                const SizedBox(width: 16),
                Icon(
                  Icons.smart_toy_outlined,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  'Model: ${pref.inferenceModel}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Preference?'),
        content: const Text(
          'This preference will no longer be applied to future impressions. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDelete?.call();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditPreferenceDialog(
        preference: widget.preference,
        onSave: widget.onEdit!,
      ),
    );
  }
}
