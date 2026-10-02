import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/app_theme.dart';
import '../../models/case.dart';

/// Timeline view showing edit history for a case
class ImpressionHistory extends StatelessWidget {
  const ImpressionHistory({
    super.key,
    required this.editHistory,
    this.baseImpression,
  });

  final List<CaseEditHistoryEntry> editHistory;
  final String? baseImpression;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userEdits =
        editHistory.where((e) => e.source == 'user_edit').toList();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.sectionHeaderDecoration(colorScheme),
            child: Row(
              children: [
                Icon(
                  Icons.history,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Edit History',
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${userEdits.length} edit${userEdits.length != 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          // Timeline
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Base impression (if available)
                if (baseImpression != null)
                  _TimelineEntry(
                    icon: Icons.auto_awesome,
                    iconColor: colorScheme.primary,
                    title: 'Base Generated',
                    subtitle: 'Initial AI generation',
                    isFirst: true,
                    isLast: editHistory.isEmpty,
                  ),
                // Edit history entries
                ...editHistory.asMap().entries.map((entry) {
                  final index = entry.key;
                  final historyEntry = entry.value;
                  final isSignificant = historyEntry.editDistance > 0.05;

                  return _TimelineEntry(
                    icon: historyEntry.source == 'generation'
                        ? Icons.tune
                        : Icons.edit,
                    iconColor: historyEntry.source == 'generation'
                        ? Colors.purple
                        : Colors.orange,
                    title: historyEntry.source == 'generation'
                        ? 'Preferences Applied'
                        : 'Edit ${index + 1}',
                    subtitle: _formatTimestamp(historyEntry.timestamp),
                    trailing: _buildEditDistance(
                        context, historyEntry.editDistance, isSignificant),
                    isFirst: baseImpression == null && index == 0,
                    isLast: index == editHistory.length - 1,
                    expandable: true,
                    expandedContent:
                        _buildExpandedContent(context, historyEntry),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(double timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).toInt());
    return DateFormat.yMMMd().add_jm().format(date);
  }

  Widget _buildEditDistance(
      BuildContext context, double editDistance, bool isSignificant) {
    final percentage = (editDistance * 100).toStringAsFixed(1);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isSignificant)
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text('⚡', style: TextStyle(fontSize: 12)),
          ),
        Text(
          '$percentage% changed',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSignificant
                    ? Colors.orange
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent(
      BuildContext context, CaseEditHistoryEntry entry) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Original:',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            entry.originalImpression,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Text(
            'Edited:',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            entry.editedImpression,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (entry.preferencesSnapshot != null &&
              entry.preferencesSnapshot!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Preferences at time of edit:',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),
            ...entry.preferencesSnapshot!.map((p) => Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Text(
                          p.preferenceText,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatefulWidget {
  const _TimelineEntry({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.isFirst = false,
    this.isLast = false,
    this.expandable = false,
    this.expandedContent,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool isFirst;
  final bool isLast;
  final bool expandable;
  final Widget? expandedContent;

  @override
  State<_TimelineEntry> createState() => _TimelineEntryState();
}

class _TimelineEntryState extends State<_TimelineEntry> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and dot
          SizedBox(
            width: 32,
            child: Column(
              children: [
                // Line above
                if (!widget.isFirst)
                  Container(
                    width: 2,
                    height: 12,
                    color: colorScheme.outlineVariant,
                  ),
                // Dot
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: widget.iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    size: 14,
                    color: widget.iconColor,
                  ),
                ),
                // Line below
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: widget.expandable
                        ? () => setState(() => _isExpanded = !_isExpanded)
                        : null,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                widget.subtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.trailing != null) widget.trailing!,
                        if (widget.expandable)
                          Icon(
                            _isExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                            size: 20,
                            color: colorScheme.onSurfaceVariant,
                          ),
                      ],
                    ),
                  ),
                  if (_isExpanded && widget.expandedContent != null) ...[
                    const SizedBox(height: 12),
                    widget.expandedContent!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
