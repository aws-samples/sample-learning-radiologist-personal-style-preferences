import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:report_preferences_web/models/user_settings.dart';
import 'package:report_preferences_web/providers/settings_provider.dart';
import 'package:report_preferences_web/services/api_service.dart';

import '_fakes.dart';

/// Tests SettingsNotifier: load, the optimistic update + rollback contract,
/// local-toggle sync, the throw-on-failure behavior, and no-loading-flicker.

void main() {
  late FakeApiService api;

  ProviderContainer makeC(UserSettings initial) {
    api = FakeApiService()..settings = initial;
    return makeContainer(api: api, addTearDown: addTearDown);
  }

  // Reading .notifier constructs SettingsNotifier (which kicks off _loadSettings);
  // pump microtasks so the initial async load resolves before assertions.
  Future<SettingsNotifier> ready(ProviderContainer c) async {
    final n = c.read(settingsNotifierProvider.notifier);
    await pumpEventQueue();
    return n;
  }

  const loaded = UserSettings(clinicalInterpretation: true, kPreferences: 7);

  group('_loadSettings', () {
    test('success: data + local toggles synced from server', () async {
      final c = makeC(loaded);
      await ready(c);
      expect(c.read(settingsNotifierProvider).value, loaded);
      expect(c.read(clinicalInterpretationProvider), true);
      expect(c.read(kPreferencesProvider), 7);
    });

    test('error: state is AsyncError', () async {
      final c = makeC(const UserSettings());
      api.settingsError = ApiException(500, 'boom');
      final n = c.read(settingsNotifierProvider.notifier);
      await pumpEventQueue();
      expect(c.read(settingsNotifierProvider).hasError, isTrue);
      expect(n, isNotNull);
    });
  });

  group('updateSettings — happy path', () {
    test('applies optimistically then re-syncs, no loading flicker', () async {
      final c = makeC(loaded);
      await ready(c);

      // Server will accept and report the new value on the follow-up getSettings.
      api.onUpdate = (_) => const UpdateSettingsResponse(success: true);
      api.settings = const UserSettings(clinicalInterpretation: false, kPreferences: 7);

      // Capture every state emission to prove we never flip to loading.
      final emissions = <AsyncValue<UserSettings>>[];
      final sub = c.listen(settingsNotifierProvider, (_, next) => emissions.add(next));
      addTearDown(sub.close);

      await c.read(settingsNotifierProvider.notifier).updateSettings(
            const UpdateSettingsRequest(clinicalInterpretation: false),
          );

      expect(emissions.any((e) => e.isLoading), isFalse,
          reason: 'optimistic update must not flip to loading');
      expect(c.read(settingsNotifierProvider).value!.clinicalInterpretation, false);
      expect(c.read(clinicalInterpretationProvider), false);
      // getSettings called twice: once on load, once on resync.
      expect(api.getSettingsCalls, 2);
    });
  });

  group('updateSettings — rollback', () {
    test('throws SettingsUpdateException and reverts on success:false', () async {
      final c = makeC(loaded);
      await ready(c);
      api.onUpdate = (_) =>
          const UpdateSettingsResponse(success: false, message: 'rejected');

      await expectLater(
        c.read(settingsNotifierProvider.notifier).updateSettings(
              const UpdateSettingsRequest(clinicalInterpretation: false),
            ),
        throwsA(isA<SettingsUpdateException>()),
      );

      // Reverted to the pre-update snapshot.
      expect(c.read(settingsNotifierProvider).value!.clinicalInterpretation, true);
      expect(c.read(clinicalInterpretationProvider), true);
    });

    test('reverts and rethrows on a thrown network error', () async {
      final c = makeC(loaded);
      await ready(c);
      api.updateError = ApiException(503, 'unavailable');

      await expectLater(
        c.read(settingsNotifierProvider.notifier).updateSettings(
              const UpdateSettingsRequest(kPreferences: 20),
            ),
        throwsA(isA<ApiException>()),
      );

      expect(c.read(settingsNotifierProvider).value!.kPreferences, 7);
      expect(c.read(kPreferencesProvider), 7);
    });
  });

  group('updateSettings — null fields', () {
    test('unspecified fields keep their current value', () async {
      final c = makeC(loaded);
      await ready(c);
      api.onUpdate = (_) => const UpdateSettingsResponse(success: true);
      // Echo the optimistic value back so resync doesn't change it.
      api.settings = const UserSettings(clinicalInterpretation: true, kPreferences: 3);

      await c.read(settingsNotifierProvider.notifier).updateSettings(
            const UpdateSettingsRequest(kPreferences: 3), // clinical not set
          );

      final s = c.read(settingsNotifierProvider).value!;
      expect(s.kPreferences, 3);
      expect(s.clinicalInterpretation, true); // unchanged
    });
  });

  group('resetApp', () {
    test('calls resetApp then refreshes', () async {
      final c = makeC(loaded);
      await ready(c);
      await c.read(settingsNotifierProvider.notifier).resetApp();
      expect(api.resetAppCalls, 1);
      expect(api.getSettingsCalls, 2); // initial load + post-reset refresh
    });
  });
}
