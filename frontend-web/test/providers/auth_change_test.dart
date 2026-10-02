import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:report_preferences_web/providers/auth_provider.dart';
import 'package:report_preferences_web/services/auth_service.dart';

import '_fakes.dart';

/// authChangeProvider must rebuild dependents on AuthService.notifyListeners().
/// Uses a FRESH FakeAuth per container (see authChangeProvider ownership note).

void main() {
  test('initial read reflects the auth service state', () {
    final auth = FakeAuth();
    final c = ProviderContainer(
      overrides: [authServiceProvider.overrideWithValue(auth)],
    );
    addTearDown(c.dispose);

    expect(c.read(authChangeProvider).isAuthenticated, isFalse);
  });

  test('notifyListeners drives a rebuild and exposes new state', () {
    final auth = FakeAuth();
    final c = ProviderContainer(
      overrides: [authServiceProvider.overrideWithValue(auth)],
    );
    addTearDown(c.dispose);

    var notifications = 0;
    final sub = c.listen(authChangeProvider, (_, __) => notifications++);
    addTearDown(sub.close);

    auth.emit(AuthState.signedIn, email: 'a@b.com');

    expect(notifications, 1);
    expect(c.read(authChangeProvider).isAuthenticated, isTrue);
    expect(c.read(authChangeProvider).userEmail, 'a@b.com');
  });

  test('multiple transitions each emit', () {
    final auth = FakeAuth();
    final c = ProviderContainer(
      overrides: [authServiceProvider.overrideWithValue(auth)],
    );
    addTearDown(c.dispose);

    var notifications = 0;
    final sub = c.listen(authChangeProvider, (_, __) => notifications++);
    addTearDown(sub.close);

    auth.emit(AuthState.signedIn);
    auth.emit(AuthState.signedOut);

    expect(notifications, 2);
    expect(c.read(authChangeProvider).authState, AuthState.signedOut);
  });
}
