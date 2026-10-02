import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/preference.dart';
import '../utils/logger.dart';
import 'api_provider.dart';

/// Sort options for preferences
enum PreferenceSort {
  recent,
  category,
  confidence,
}

/// Tab selection for preferences view
enum PreferencesTab {
  learned,
  rejected,
}

/// Provider for current preferences tab
final preferencesTabProvider =
    StateProvider<PreferencesTab>((ref) => PreferencesTab.learned);

/// Provider for preference sort option
final preferenceSortProvider =
    StateProvider<PreferenceSort>((ref) => PreferenceSort.recent);

/// Provider for preference search query
final preferenceSearchProvider = StateProvider<String>((ref) => '');

/// Provider for fetching learned preferences.
/// autoDispose: user-scoped data must not outlive the session.
final preferencesProvider =
    FutureProvider.autoDispose<List<Preference>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  try {
    devLog('[PreferencesProvider] Fetching preferences...');
    final response = await apiService.getPreferences();
    devLog(
        '[PreferencesProvider] Got ${response.preferences.length} preferences');
    return response.preferences;
  } catch (e) {
    devLog('[PreferencesProvider] Error fetching preferences');
    rethrow;
  }
});

/// Provider for fetching rejected preferences.
/// autoDispose: user-scoped data must not outlive the session.
final rejectedPreferencesProvider =
    FutureProvider.autoDispose<List<RejectedPreference>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final response = await apiService.getRejectedPreferences();
  return response.rejectedPreferences;
});

/// Provider for sorted and filtered preferences
final sortedPreferencesProvider =
    Provider.autoDispose<AsyncValue<List<Preference>>>((ref) {
  final prefsAsync = ref.watch(preferencesProvider);
  final sort = ref.watch(preferenceSortProvider);
  final search = ref.watch(preferenceSearchProvider).toLowerCase();

  // .when (not .whenData) so a throwing sort/filter surfaces as AsyncError.
  return prefsAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (prefs) {
      // Create a mutable copy (Freezed lists are unmodifiable)
      var filtered = prefs.toList();

      // Apply search
      if (search.isNotEmpty) {
        filtered = filtered
            .where((p) =>
                p.preferenceText.toLowerCase().contains(search) ||
                (p.category?.toLowerCase().contains(search) ?? false))
            .toList();
      }

      // Apply sort
      switch (sort) {
        case PreferenceSort.recent:
          filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          break;
        case PreferenceSort.category:
          filtered.sort(
              (a, b) => (a.category ?? 'zzz').compareTo(b.category ?? 'zzz'));
          break;
        case PreferenceSort.confidence:
          filtered
              .sort((a, b) => (b.confidence ?? 0).compareTo(a.confidence ?? 0));
          break;
      }

      return AsyncValue.data(filtered);
    },
  );
});

/// Provider for sorted and filtered rejected preferences
final sortedRejectedPreferencesProvider =
    Provider.autoDispose<AsyncValue<List<RejectedPreference>>>((ref) {
  final prefsAsync = ref.watch(rejectedPreferencesProvider);
  final search = ref.watch(preferenceSearchProvider).toLowerCase();

  return prefsAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (prefs) {
      // Create a mutable copy (Freezed lists are unmodifiable)
      var filtered = prefs.toList();

      // Apply search
      if (search.isNotEmpty) {
        filtered = filtered
            .where((p) =>
                p.changeDescription.toLowerCase().contains(search) ||
                p.rejectionReason.toLowerCase().contains(search))
            .toList();
      }

      // Sort by timestamp (most recent first)
      filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return AsyncValue.data(filtered);
    },
  );
});
