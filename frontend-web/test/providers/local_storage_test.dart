import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:report_preferences_web/providers/local_storage_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// hasNewPreferencesProvider seeds its initial value from SharedPreferences;
/// sharedPreferencesProvider must be overridden or it throws.

void main() {
  Future<ProviderContainer> withPrefs(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    final prefs = await SharedPreferences.getInstance();
    final c = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('true when the stored flag is true', () async {
    final c = await withPrefs({kHasNewPreferencesKey: true});
    expect(c.read(hasNewPreferencesProvider), isTrue);
  });

  test('false when the stored flag is false', () async {
    final c = await withPrefs({kHasNewPreferencesKey: false});
    expect(c.read(hasNewPreferencesProvider), isFalse);
  });

  test('defaults to false when the key is absent', () async {
    final c = await withPrefs(const {});
    expect(c.read(hasNewPreferencesProvider), isFalse);
  });

  test('sharedPreferencesProvider throws when not overridden', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    expect(() => c.read(sharedPreferencesProvider), throwsUnimplementedError);
  });
}
