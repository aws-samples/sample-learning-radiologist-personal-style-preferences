import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/preference.dart';
import '../../utils/formatters.dart';

/// Card row for displaying a rejected preference change
class RejectedPreferenceRow extends StatefulWidget {
  const RejectedPreferenceRow({
    super.key,
    required this.preference,
  });

  final RejectedPreference preference;

  @override
  State<RejectedPreferenceRow> createState() => _RejectedPreferenceRowState();
}

class _RejectedPreferenceRowState extends State<RejectedPreferenceRow> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pref = widget.preference;
    final riskColor = Theme.of(context).extension<RiskColorsTheme>()!.getColor(pref.riskLevel);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                // Risk level color bar
                Container(
                  width: 4,
                  height: 72,
                  decoration: BoxDecoration(
                    color: riskColor,
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
                                Icon(
                                  Icons.block,
                                  size: 16,
                                  color: colorScheme.error,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Rejected',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: colorScheme.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                if (pref.riskLevel != null) ...[
                                  const SizedBox(width: 8),
                                  _RiskBadge(riskLevel: pref.riskLevel!),
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
                        // Change description
                        Text(
                          pref.changeDescription,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                // Expand icon
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Expanded details
          if (_isExpanded) _buildDetails(context),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pref = widget.preference;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.2),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rejection reason
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber,
                size: 16,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reason',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pref.rejectionReason,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Rejection layer
          Row(
            children: [
              Icon(
                Icons.layers_outlined,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Layer: ${_formatLayer(pref.rejectionLayer)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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

  String _formatLayer(String layer) {
    switch (layer) {
      case 'confidence_threshold':
        return 'Low Confidence';
      case 'keyword_filter':
        return 'Keyword Filter';
      case 'validator_agent':
        return 'Safety Validator';
      case 'llm_classification':
        return 'LLM Classification';
      default:
        return layer;
    }
  }
}

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({required this.riskLevel});

  final String riskLevel;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<RiskColorsTheme>()!.getColor(riskLevel);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            riskLevel == 'high'
                ? Icons.error
                : riskLevel == 'medium'
                    ? Icons.warning
                    : Icons.info_outline,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '${riskLevel.substring(0, 1).toUpperCase()}${riskLevel.substring(1)} Risk',
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
