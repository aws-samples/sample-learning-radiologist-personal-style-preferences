import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:report_preferences_web/providers/auth_provider.dart';
import 'package:report_preferences_web/providers/cases_provider.dart';
import 'package:report_preferences_web/providers/local_storage_provider.dart';
import 'package:report_preferences_web/providers/preferences_provider.dart';
import 'package:report_preferences_web/screens/main_shell.dart';
import 'package:report_preferences_web/screens/onboarding/onboarding_dialog.dart';
import 'package:report_preferences_web/services/auth_service.dart';

/// Minimal stub AuthService that reports "signed in" without Amplify.
class _StubAuthService extends AuthService {
  @override
  bool get isAuthenticated => true;

  @override
  AuthState get authState => AuthState.signedIn;

  @override
  String? get userEmail => 'test@example.com';

  @override
  String get userInitials => 'TE';
}

/// Builds a router that renders [MainShell] at `/cases`.
GoRouter _router(_StubAuthService auth) => GoRouter(
      initialLocation: '/cases',
      redirect: (_, __) => null,
      routes: [
        ShellRoute(
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(
              path: '/cases',
              builder: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );

Widget _buildApp({
  required SharedPreferences prefs,
  required _StubAuthService auth,
}) {
  final router = _router(auth);
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      authServiceProvider.overrideWithValue(auth),
      // Preferences never return data in these tests (never empty→non-empty transition).
      preferencesProvider.overrideWith((_) async => []),
      rejectedPreferencesProvider.overrideWith((_) async => []),
      casesProvider.overrideWith((_) async => []),
      selectedCaseIdProvider.overrideWith((ref) => null),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  late SharedPreferences prefs;
  late _StubAuthService auth;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    auth = _StubAuthService();
  });

  // ===========================================================================
  // F6 regression — _checkOnboarding() must rely solely on the persisted flag
  // ===========================================================================

  group('onboarding dialog visibility', () {
    testWidgets(
        'does NOT show when kOnboardingShownKey is true (returning user)',
        (tester) async {
      await prefs.setBool(kOnboardingShownKey, true);

      await tester.pumpWidget(_buildApp(prefs: prefs, auth: auth));
      // Process the postFrameCallback + any async microtasks.
      await tester.pump();
      await tester.pump();

      expect(find.byType(OnboardingDialog), findsNothing);
    });

    testWidgets(
        'shows when kOnboardingShownKey is absent (first-time user)',
        (tester) async {
      // No flag set — fresh SharedPreferences from setUp.

      await tester.pumpWidget(_buildApp(prefs: prefs, auth: auth));
      // First pump processes the frame; second pump fires the postFrameCallback.
      await tester.pump();
      await tester.pump();

      expect(find.byType(OnboardingDialog), findsOneWidget);
    });
  });
}
