import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Storage keys
const kOnboardingShownKey = 'onboarding_shown';
const kFirstPreferenceConfettiKey = 'first_preference_confetti_shown';
const kHasNewPreferencesKey = 'has_new_preferences';
const kCaseSidebarWidthKey = 'case_sidebar_width';

/// Provider for SharedPreferences instance — overridden in main.dart
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Whether there are new (unseen) preferences — persisted across sessions
final hasNewPreferencesProvider = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool(kHasNewPreferencesKey) ?? false;
});
