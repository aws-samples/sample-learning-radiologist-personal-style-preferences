import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_theme.dart';
import '../../models/preference.dart';
import '../../providers/preferences_provider.dart';
import '../../utils/error_messages.dart';
import '../../utils/formatters.dart';
import '../../widgets/common/floating_icon.dart';
import '../../widgets/preferences/category_badge.dart';

/// Insights dashboard showing preference learning statistics and activity
class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(preferencesProvider);
    final rejectedAsync = ref.watch(rejectedPreferencesProvider);

    return prefsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text('Error loading preferences: ${friendlyError(e)}')),
      data: (prefs) {
        final rejected = rejectedAsync.valueOrNull ?? [];
        if (prefs.isEmpty && rejected.isEmpty) {
          return _buildEmptyState(context);
        }
        return _buildDashboard(context, prefs, rejected);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingIcon(
            icon: Icons.insights_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No data yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate and edit impressions to start seeing insights.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    List<Preference> prefs,
    List<RejectedPreference> rejected,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Insights',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Preference learning statistics and activity',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),

          // Summary stats
          _SummaryStatsRow(
            learnedCount: prefs.length,
            rejectedCount: rejected.length,
          ),
          const SizedBox(height: 24),

          // Charts row
          _ChartsRow(prefs: prefs),
          const SizedBox(height: 24),

          // Recent activity
          _RecentActivityCard(prefs: prefs),
        ],
      ),
    );
  }
}

// ── Summary Stats ──────────────────────────────────────────────────────

class _SummaryStatsRow extends StatelessWidget {
  const _SummaryStatsRow({
    required this.learnedCount,
    required this.rejectedCount,
  });

  final int learnedCount;
  final int rejectedCount;

  @override
  Widget build(BuildContext context) {
    final total = learnedCount + rejectedCount;
    final acceptanceRate = total > 0 ? (learnedCount / total * 100) : 0.0;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_outline,
            iconColor: colorScheme.secondary,
            value: '$learnedCount',
            label: 'Learned',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            icon: Icons.block_outlined,
            iconColor: colorScheme.error,
            value: '$rejectedCount',
            label: 'Rejected',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            icon: Icons.pie_chart_outline,
            iconColor: colorScheme.tertiary,
            value: '${acceptanceRate.round()}%',
            label: 'Acceptance Rate',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: AppTheme.sectionHeaderDecoration(colorScheme),
            child: Row(
              children: [
                Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Charts ─────────────────────────────────────────────────────────────

class _ChartsRow extends StatelessWidget {
  const _ChartsRow({required this.prefs});

  final List<Preference> prefs;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _CategoryBreakdownCard(prefs: prefs)),
        const SizedBox(width: 16),
        Expanded(child: _ConfidenceDistributionCard(prefs: prefs)),
      ],
    );
  }
}

class _CategoryBreakdownCard extends StatelessWidget {
  const _CategoryBreakdownCard({required this.prefs});

  final List<Preference> prefs;

  static const _categories = [
    'terminology',
    'formatting',
    'detail_level',
    'phrasing',
    'priority',
  ];

  static const _categoryLabels = {
    'terminology': 'Terminology',
    'formatting': 'Formatting',
    'detail_level': 'Detail Level',
    'phrasing': 'Phrasing',
    'priority': 'Priority',
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoryColors = Theme.of(context).extension<CategoryColorsTheme>()!;

    // Count prefs per category
    final counts = <String, int>{};
    for (final p in prefs) {
      final cat = p.category ?? 'other';
      counts[cat] = (counts[cat] ?? 0) + 1;
    }

    final maxCount = counts.values.fold<int>(0, math.max);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: AppTheme.sectionHeaderDecoration(colorScheme),
            child: Row(
              children: [
                Icon(Icons.bar_chart, size: 18,
                    color: colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Text(
                  'Category Breakdown',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 200,
              child: maxCount == 0
                  ? Center(
                      child: Text(
                        'No categorized preferences',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxCount.toDouble() + 1,
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx < 0 || idx >= _categories.length) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    _categoryLabels[_categories[idx]]!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(fontSize: 9),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                if (value == value.roundToDouble() &&
                                    value >= 0) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall,
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color:
                                colorScheme.outlineVariant.withValues(alpha: 0.3),
                            strokeWidth: 1,
                          ),
                          drawVerticalLine: false,
                        ),
                        barGroups: List.generate(_categories.length, (i) {
                          final cat = _categories[i];
                          final count = (counts[cat] ?? 0).toDouble();
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: count,
                                color: categoryColors.getColor(cat),
                                width: 20,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4)),
                              ),
                            ],
                          );
                        }),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final cat = _categories[group.x];
                              return BarTooltipItem(
                                '${_categoryLabels[cat]}: ${rod.toY.toInt()}',
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.white,
                                    ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfidenceDistributionCard extends StatelessWidget {
  const _ConfidenceDistributionCard({required this.prefs});

  final List<Preference> prefs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Bucket prefs by confidence
    int low = 0, medium = 0, high = 0;
    for (final p in prefs) {
      final c = p.confidence ?? 0.0;
      if (c >= 0.8) {
        high++;
      } else if (c >= 0.6) {
        medium++;
      } else {
        low++;
      }
    }

    final maxCount = [low, medium, high].fold<int>(0, math.max);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: AppTheme.sectionHeaderDecoration(colorScheme),
            child: Row(
              children: [
                Icon(Icons.equalizer, size: 18,
                    color: colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Text(
                  'Confidence Distribution',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 200,
              child: maxCount == 0
                  ? Center(
                      child: Text(
                        'No confidence data',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxCount.toDouble() + 1,
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                const labels = ['Low\n<60%', 'Medium\n60-80%', 'High\n>80%'];
                                final idx = value.toInt();
                                if (idx < 0 || idx >= labels.length) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    labels[idx],
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(fontSize: 9),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                if (value == value.roundToDouble() &&
                                    value >= 0) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall,
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color:
                                colorScheme.outlineVariant.withValues(alpha: 0.3),
                            strokeWidth: 1,
                          ),
                          drawVerticalLine: false,
                        ),
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: low.toDouble(),
                                color: Colors.grey,
                                width: 28,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4)),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: medium.toDouble(),
                                color: Colors.amber,
                                width: 28,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4)),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: high.toDouble(),
                                color: Colors.green,
                                width: 28,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4)),
                              ),
                            ],
                          ),
                        ],
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              const labels = ['Low', 'Medium', 'High'];
                              return BarTooltipItem(
                                '${labels[group.x]}: ${rod.toY.toInt()}',
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.white,
                                    ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Recent Activity ────────────────────────────────────────────────────

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard({required this.prefs});

  final List<Preference> prefs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoryColors = Theme.of(context).extension<CategoryColorsTheme>()!;

    // Sort by timestamp desc, take last 10
    final sorted = prefs.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final recent = sorted.take(10).toList();

    if (recent.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: AppTheme.sectionHeaderDecoration(colorScheme),
            child: Row(
              children: [
                Icon(Icons.history, size: 18,
                    color: colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recent.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final pref = recent[index];
              final catColor =
                  categoryColors.getColor(pref.category);

              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: catColor, width: 3),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pref.preferenceText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
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
                    ),
                    const SizedBox(width: 12),
                    if (pref.category != null)
                      CategoryBadge(category: pref.category!),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
