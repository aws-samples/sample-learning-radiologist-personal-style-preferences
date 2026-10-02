// Settings state. The optimistic-update + rollback contract and the
// "not autoDispose" rationale are documented in docs/state-management.md.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_settings.dart';
import '../utils/logger.dart';
import 'api_provider.dart';

/// Thrown when the settings API handles the request but reports failure
/// (`success: false`), e.g. a validation/safety rejection. Distinct from a
/// network/parse error (a `DioException`); both trigger rollback, and both are
/// surfaced to the user via `friendlyError`.
class SettingsUpdateException implements Exception {
  SettingsUpdateException(this.message);

  final String message;

  @override
  String toString() => 'SettingsUpdateException: $message';
}

/// Provider for fetching user settings
final settingsProvider = FutureProvider<UserSettings>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getSettings();
});

/// Provider for clinical interpretation setting (local state)
final clinicalInterpretationProvider = StateProvider<bool>((ref) {
  // Default to true (on); synced from API once settings load.
  return true;
});

/// Provider for k_preferences setting (local state)
final kPreferencesProvider = StateProvider<int>((ref) {
  return 10;
});

/// Notifier for managing settings state
class SettingsNotifier extends StateNotifier<AsyncValue<UserSettings>> {
  SettingsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  final Ref _ref;

  Future<void> _loadSettings() async {
    try {
      final apiService = _ref.read(apiServiceProvider);
      final settings = await apiService.getSettings();
      state = AsyncValue.data(settings);

      // Sync local state
      _ref.read(clinicalInterpretationProvider.notifier).state =
          settings.clinicalInterpretation;
      _ref.read(kPreferencesProvider.notifier).state = settings.kPreferences;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Re-fetch authoritative settings WITHOUT flipping to a loading state.
  /// Used after an optimistic update succeeds so the just-applied value stays
  /// visible (no spinner flicker) until the server value replaces it.
  Future<void> _resync() => _loadSettings();

  /// Re-fetch settings, showing a loading state first. For explicit refreshes
  /// (pull-to-refresh, post-reset) where a spinner is appropriate.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadSettings();
  }

  Future<UpdateSettingsResponse> updateSettings(
      UpdateSettingsRequest request) async {
    devLog('[SettingsNotifier] updateSettings called');

    // Snapshot prior state so we can roll back if the request fails.
    final priorState = state;
    final priorClinical = _ref.read(clinicalInterpretationProvider);
    final priorK = _ref.read(kPreferencesProvider);

    // Apply optimistically so the UI reflects the change immediately.
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(
        clinicalInterpretation:
            request.clinicalInterpretation ?? current.clinicalInterpretation,
        kPreferences: request.kPreferences ?? current.kPreferences,
        modelSettings: request.modelSettings ?? current.modelSettings,
        dataSource: request.dataSource ?? current.dataSource,
        mimicBucket: request.mimicBucket ?? current.mimicBucket,
      ));
    }
    if (request.clinicalInterpretation != null) {
      _ref.read(clinicalInterpretationProvider.notifier).state =
          request.clinicalInterpretation!;
    }
    if (request.kPreferences != null) {
      _ref.read(kPreferencesProvider.notifier).state = request.kPreferences!;
    }

    try {
      final apiService = _ref.read(apiServiceProvider);
      final response = await apiService.updateSettings(request);
      devLog('[SettingsNotifier] Response: '
          'success=${response.success}, dataReset=${response.dataReset}');

      if (!response.success) {
        // Handled rejection (e.g. validation/safety): revert and surface it.
        // Throwing (rather than returning) ensures the caller's catch shows the
        // error instead of the setting silently reverting.
        _rollback(priorState, priorClinical, priorK);
        throw SettingsUpdateException(
            response.message ?? 'The settings update was rejected.');
      }

      // Re-sync authoritative server values without a loading flicker.
      await _resync();
      return response;
    } on SettingsUpdateException {
      rethrow;
    } catch (e) {
      // Network/parse failure — revert optimistic changes and surface the error.
      _rollback(priorState, priorClinical, priorK);
      rethrow;
    }
  }

  /// Restore settings state + local toggles to a pre-update snapshot.
  void _rollback(
    AsyncValue<UserSettings> priorState,
    bool priorClinical,
    int priorK,
  ) {
    state = priorState;
    _ref.read(clinicalInterpretationProvider.notifier).state = priorClinical;
    _ref.read(kPreferencesProvider.notifier).state = priorK;
  }

  Future<void> resetApp() async {
    final apiService = _ref.read(apiServiceProvider);
    await apiService.resetApp();
    await refresh();
  }
}

/// Provider for settings notifier
final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<UserSettings>>((ref) {
  return SettingsNotifier(ref);
});
