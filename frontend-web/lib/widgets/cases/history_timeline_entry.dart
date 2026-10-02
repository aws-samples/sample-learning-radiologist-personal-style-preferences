import 'package:flutter/material.dart';

import '../../models/case.dart';

/// Timeline entry for edit history
class HistoryTimelineEntry extends StatefulWidget {
  const HistoryTimelineEntry({
    super.key,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.color,
    required this.editDistance,
    required this.isSignificant,
    required this.isLast,
    this.preferencesSnapshot,
  });

  final int number;
  final String title;
  final String subtitle;
  final String content;
  final Color color;
  final double editDistance;
  final bool isSignificant;
  final bool isLast;
  final List<CaseAppliedPreference>? preferencesSnapshot;

  @override
  State<HistoryTimelineEntry> createState() => _HistoryTimelineEntryState();
}

class _HistoryTimelineEntryState extends State<HistoryTimelineEntry> {
  bool _showPreferences = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasPreferences = widget.preferencesSnapshot != null &&
        widget.preferencesSnapshot!.isNotEmpty;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator with number
          SizedBox(
            width: 32,
            child: Column(
              children: [
                // Number circle
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${widget.number}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                      ),
                    ),
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
              padding: EdgeInsets.only(bottom: widget.isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: widget.color,
                            ),
                          ),
                          // Preferences toggle
                          if (hasPreferences) ...[
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => setState(() => _showPreferences = !_showPreferences),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.lightbulb, size: 12, color: Colors.orange),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${widget.preferencesSnapshot!.length}',
                                    style: const TextStyle(fontSize: 11, color: Colors.orange),
                                  ),
                                  Icon(
                                    _showPreferences ? Icons.expand_less : Icons.expand_more,
                                    size: 14,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      // Edit distance
                      if (widget.editDistance > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.isSignificant)
                              const Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Text('⚡', style: TextStyle(fontSize: 10)),
                              ),
                            Text(
                              '${(widget.editDistance * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 10,
                                color: widget.isSignificant
                                    ? Colors.orange
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  // Subtitle
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Content preview
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.content,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Preferences snapshot
                  if (_showPreferences && hasPreferences) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.schedule, size: 10, color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text(
                                'Preferences snapshot (at generation time):',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ...widget.preferencesSnapshot!.map((pref) => Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.lightbulb_outline, size: 12, color: Colors.orange),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        pref.preferenceText,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
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
