import 'package:flutter/material.dart';

import '../../config/api_constants.dart';
import '../../models/case.dart';

/// Row item for case list with hover effect
class CaseRow extends StatefulWidget {
  const CaseRow({
    super.key,
    required this.caseItem,
    required this.isSelected,
    required this.onTap,
  });

  final Case caseItem;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<CaseRow> createState() => _CaseRowState();
}

class _CaseRowState extends State<CaseRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = widget.caseItem.hasGenerated ? Colors.green : Colors.grey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? colorScheme.primaryContainer
                : _isHovered
                    ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.7)
                    : colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.isSelected
                  ? colorScheme.primary
                  : _isHovered
                      ? colorScheme.outlineVariant
                      : colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: widget.isSelected ? 1.5 : 1,
            ),
            boxShadow: _isHovered || widget.isSelected
                ? [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(10),
              child: Row(
                children: [
                  // Status indicator bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: TimingConstants.microAnimationMs),
                    width: widget.isSelected ? 5 : 4,
                    height: 68,
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? statusColor
                          : statusColor.withValues(alpha: 0.7),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      boxShadow: widget.isSelected
                          ? [
                              BoxShadow(
                                color: statusColor.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(1, 0),
                              ),
                            ]
                          : null,
                    ),
                  ),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Case ${widget.caseItem.caseId}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: widget.isSelected
                                            ? colorScheme.onPrimaryContainer
                                            : null,
                                      ),
                                ),
                              ),
                              _StatusBadge(
                                label: widget.caseItem.hasGenerated ? 'Done' : 'New',
                                color: statusColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.caseItem.findings,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: widget.isSelected
                                          ? colorScheme.onPrimaryContainer
                                              .withValues(alpha: 0.8)
                                          : colorScheme.onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.withValues(alpha: 0.9),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
