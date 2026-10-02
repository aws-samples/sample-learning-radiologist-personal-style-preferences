import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/cases_provider.dart';
import '../../widgets/cases/case_row.dart';
import '../../widgets/cases/filter_chip.dart';
import '../../widgets/common/search_field.dart';

/// Sidebar view showing list of cases with search and filters
class CaseListView extends ConsumerWidget {
  const CaseListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final casesAsync = ref.watch(filteredCasesProvider);
    final selectedCaseId = ref.watch(selectedCaseIdProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(color: colorScheme.outlineVariant),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cases',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              // Search field
              SearchField(
                hintText: 'Search cases...',
                provider: caseSearchProvider,
              ),
              const SizedBox(height: 12),
              // Filter chips
              const _FilterChips(),
            ],
          ),
        ),
        // Case list
        Expanded(
          child: casesAsync.when(
            data: (cases) {
              if (cases.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No cases found',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => ref.refresh(casesProvider.future),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: cases.length,
                  itemBuilder: (context, index) {
                    final caseItem = cases[index];
                    return CaseRow(
                      caseItem: caseItem,
                      isSelected: caseItem.caseId == selectedCaseId,
                      onTap: () {
                        ref.read(selectedCaseIdProvider.notifier).state =
                            caseItem.caseId;
                      },
                    );
                  },
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error loading cases',
                    style: TextStyle(color: colorScheme.error),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => ref.invalidate(casesProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterChips extends ConsumerWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(caseFilterProvider);
    final countsAsync = ref.watch(caseFilterCountsProvider);
    final counts = countsAsync.valueOrNull;

    return Row(
      children: [
        Flexible(
          child: CaseFilterChip(
            label: 'All',
            icon: Icons.list,
            isSelected: currentFilter == CaseFilter.all,
            count: counts?[CaseFilter.all],
            onTap: () =>
                ref.read(caseFilterProvider.notifier).state = CaseFilter.all,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: CaseFilterChip(
            label: 'New',
            icon: Icons.fiber_new_outlined,
            isSelected: currentFilter == CaseFilter.new_,
            count: counts?[CaseFilter.new_],
            onTap: () =>
                ref.read(caseFilterProvider.notifier).state = CaseFilter.new_,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: CaseFilterChip(
            label: 'Done',
            icon: Icons.check_circle_outline,
            isSelected: currentFilter == CaseFilter.done,
            count: counts?[CaseFilter.done],
            onTap: () =>
                ref.read(caseFilterProvider.notifier).state = CaseFilter.done,
          ),
        ),
      ],
    );
  }
}
