import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

/// Provider for the auth service singleton.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Reactive view of the auth service.
///
/// [AuthService] is a [ChangeNotifier]; watching this provider rebuilds
/// dependents exactly when it calls notifyListeners(). Prefer this over watching
/// [authServiceProvider] (a plain Provider that never re-emits) anywhere UI
/// should react to auth-state / user-attribute changes.
///
/// (Replaces a former StreamProvider that polled authState every 100ms.)
///
/// OWNERSHIP / LIFECYCLE — do not make this `.autoDispose` and do not give it a
/// family. `ChangeNotifierProvider` calls `dispose()` on its notifier when the
/// provider element is disposed (flutter_riverpod change_notifier base), but the
/// [AuthService] instance is *owned* by [authServiceProvider] (a singleton). As
/// long as this provider stays always-alive it is only torn down with the whole
/// container, so the shared instance is never disposed out from under another
/// watcher. In tests, use a FRESH AuthService per [ProviderContainer] — sharing
/// one across containers means the first container's teardown disposes it.
final authChangeProvider = ChangeNotifierProvider<AuthService>((ref) {
  return ref.watch(authServiceProvider);
});
