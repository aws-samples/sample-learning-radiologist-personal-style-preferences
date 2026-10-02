// Case list/detail state. See docs/state-management.md for the provider graph
// and the autoDispose lifecycle policy.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/case.dart';
import 'api_provider.dart';

/// Filter state for case list
enum CaseFilter {
  all,
  new_,
  done,
}

/// Provider for current case filter
final caseFilterProvider = StateProvider<CaseFilter>((ref) => CaseFilter.all);

/// Provider for case search query
final caseSearchProvider = StateProvider<String>((ref) => '');

/// Provider for fetching all cases.
/// autoDispose: user-scoped data must not outlive the session (cleared on logout).
final casesProvider = FutureProvider.autoDispose<List<Case>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final response = await apiService.getCases();
  return response.cases;
});

/// Provider for filter counts (search-filtered only, not category-filtered)
final caseFilterCountsProvider =
    Provider.autoDispose<AsyncValue<Map<CaseFilter, int>>>((ref) {
  final casesAsync = ref.watch(casesProvider);
  final search = ref.watch(caseSearchProvider).toLowerCase();

  // .when (not .whenData) so a throwing transform surfaces as AsyncError
  // rather than escaping as an uncaught provider exception.
  return casesAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (cases) {
      var searchFiltered = cases;
      if (search.isNotEmpty) {
        searchFiltered = searchFiltered
            .where((c) =>
                c.caseId.toLowerCase().contains(search) ||
                c.findings.toLowerCase().contains(search))
            .toList();
      }

      return AsyncValue.data({
        CaseFilter.all: searchFiltered.length,
        CaseFilter.new_: searchFiltered.where((c) => !c.hasGenerated).length,
        CaseFilter.done: searchFiltered.where((c) => c.hasGenerated).length,
      });
    },
  );
});

/// Provider for filtered cases based on filter and search
final filteredCasesProvider =
    Provider.autoDispose<AsyncValue<List<Case>>>((ref) {
  final casesAsync = ref.watch(casesProvider);
  final filter = ref.watch(caseFilterProvider);
  final search = ref.watch(caseSearchProvider).toLowerCase();

  return casesAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (cases) {
      var filtered = cases;

      // Apply filter
      switch (filter) {
        case CaseFilter.all:
          break;
        case CaseFilter.new_:
          filtered = filtered.where((c) => !c.hasGenerated).toList();
          break;
        case CaseFilter.done:
          filtered = filtered.where((c) => c.hasGenerated).toList();
          break;
      }

      // Apply search
      if (search.isNotEmpty) {
        filtered = filtered
            .where((c) =>
                c.caseId.toLowerCase().contains(search) ||
                c.findings.toLowerCase().contains(search))
            .toList();
      }

      return AsyncValue.data(filtered);
    },
  );
});

/// Provider for currently selected case ID
final selectedCaseIdProvider = StateProvider<String?>((ref) => null);

/// Provider for fetching case detail.
/// autoDispose + family: one entry per visited case — must not accumulate.
final caseDetailProvider =
    FutureProvider.autoDispose.family<CaseDetail, String>((ref, caseId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getCaseDetail(caseId);
});
