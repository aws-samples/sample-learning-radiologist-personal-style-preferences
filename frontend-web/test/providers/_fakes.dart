// Shared test doubles for provider tests.
//
// The whole data layer is reached through `apiServiceProvider`, so tests
// override that single provider with a [FakeApiService] and never touch Dio.
// No mockito: ApiService has no interface and only a handful of methods matter
// here, so a hand-written subclass is simpler and codegen-free.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:report_preferences_web/models/case.dart';
import 'package:report_preferences_web/models/preference.dart';
import 'package:report_preferences_web/models/user_settings.dart';
import 'package:report_preferences_web/providers/api_provider.dart';
import 'package:report_preferences_web/providers/auth_provider.dart';
import 'package:report_preferences_web/services/api_service.dart';
import 'package:report_preferences_web/services/auth_service.dart';

/// Programmable fake of [ApiService].
///
/// `ApiService`'s constructor builds a Dio with interceptors, but those only
/// fire on real HTTP calls; overriding the public methods never touches `_dio`,
/// so constructing this is inert. The base ctor needs an [AuthService] — its
/// default constructor does no Amplify work, so `AuthService()` is safe.
class FakeApiService extends ApiService {
  FakeApiService() : super(AuthService());

  // ----- programmable returns -----
  List<Case> cases = const [];
  List<Preference> prefs = const [];
  List<RejectedPreference> rejected = const [];
  UserSettings settings = const UserSettings();

  // ----- programmable errors (if set, the matching call throws) -----
  Object? casesError;
  Object? prefsError;
  Object? rejectedError;
  Object? settingsError;
  Object? updateError;

  /// Builds the response for `updateSettings`; default is success.
  UpdateSettingsResponse Function(UpdateSettingsRequest request)? onUpdate;

  // ----- call counters (for dispose/invalidate + resync assertions) -----
  int getCasesCalls = 0;
  int getPreferencesCalls = 0;
  int getRejectedCalls = 0;
  int getSettingsCalls = 0;
  int updateSettingsCalls = 0;
  int resetAppCalls = 0;

  @override
  Future<CasesResponse> getCases() async {
    getCasesCalls++;
    if (casesError != null) throw casesError!;
    return CasesResponse(count: cases.length, cases: cases);
  }

  @override
  Future<PreferencesResponse> getPreferences() async {
    getPreferencesCalls++;
    if (prefsError != null) throw prefsError!;
    return PreferencesResponse(count: prefs.length, preferences: prefs);
  }

  @override
  Future<RejectedPreferencesResponse> getRejectedPreferences() async {
    getRejectedCalls++;
    if (rejectedError != null) throw rejectedError!;
    return RejectedPreferencesResponse(
      count: rejected.length,
      rejectedPreferences: rejected,
    );
  }

  @override
  Future<UserSettings> getSettings() async {
    getSettingsCalls++;
    if (settingsError != null) throw settingsError!;
    return settings;
  }

  @override
  Future<UpdateSettingsResponse> updateSettings(
      UpdateSettingsRequest request) async {
    updateSettingsCalls++;
    if (updateError != null) throw updateError!;
    return onUpdate?.call(request) ??
        const UpdateSettingsResponse(success: true);
  }

  @override
  Future<void> resetApp() async {
    resetAppCalls++;
  }
}

/// Mutable [AuthService] fake — `emit` flips state and notifies listeners so
/// `authChangeProvider` rebuilds. A FRESH instance per container (see the
/// ownership note on authChangeProvider).
class FakeAuth extends AuthService {
  AuthState _state = AuthState.signedOut;
  String? _email;

  @override
  AuthState get authState => _state;

  @override
  String? get userEmail => _email;

  @override
  bool get isAuthenticated => _state == AuthState.signedIn;

  void emit(AuthState state, {String? email}) {
    _state = state;
    if (email != null) _email = email;
    notifyListeners();
  }
}

/// Build a [ProviderContainer] with the API (and optionally auth) faked, with
/// teardown wired up. Pass `addTearDown` from the test so disposal is automatic.
ProviderContainer makeContainer({
  required FakeApiService api,
  FakeAuth? auth,
  void Function(void Function())? addTearDown,
  List<Override> extra = const [],
}) {
  final container = ProviderContainer(
    overrides: [
      apiServiceProvider.overrideWithValue(api),
      if (auth != null) authServiceProvider.overrideWithValue(auth),
      ...extra,
    ],
  );
  addTearDown?.call(container.dispose);
  return container;
}
