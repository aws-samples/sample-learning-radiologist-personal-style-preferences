import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';

import '../utils/logger.dart';

/// Authentication state
enum AuthState {
  loading,
  signedOut,
  signedIn,
  newPasswordRequired,
}

/// Authentication service using Amplify Cognito
class AuthService extends ChangeNotifier {
  AuthState _authState = AuthState.loading;
  String? _userEmail;
  String? _errorMessage;

  AuthState get authState => _authState;
  String? get userEmail => _userEmail;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authState == AuthState.signedIn;

  /// Get user initials for display
  String get userInitials {
    if (_userEmail == null) return '?';
    final parts = _userEmail!.split('@').first.split(RegExp(r'[.\-_]'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return _userEmail!.substring(0, 2).toUpperCase();
  }

  /// Check current authentication status on app start
  Future<void> checkAuthStatus() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        await _fetchUserEmail();
        _authState = AuthState.signedIn;
      } else {
        _authState = AuthState.signedOut;
      }
    } catch (e) {
      devLog('Error checking auth status: $e');
      _authState = AuthState.signedOut;
    }
    notifyListeners();
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        await _fetchUserEmail();
        _authState = AuthState.signedIn;
      } else if (result.nextStep.signInStep ==
          AuthSignInStep.confirmSignInWithNewPassword) {
        _userEmail = email;
        _authState = AuthState.newPasswordRequired;
      } else {
        _errorMessage = 'Unexpected sign-in step: ${result.nextStep.signInStep}';
        _authState = AuthState.signedOut;
      }
    } on AuthException catch (e) {
      _errorMessage = _mapAuthError(e);
      _authState = AuthState.signedOut;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _authState = AuthState.signedOut;
    }
    notifyListeners();
  }

  /// Confirm sign-in with new password (first login)
  Future<void> confirmSignInWithNewPassword(String newPassword) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await Amplify.Auth.confirmSignIn(
        confirmationValue: newPassword,
      );

      if (result.isSignedIn) {
        await _fetchUserEmail();
        _authState = AuthState.signedIn;
      } else {
        _errorMessage =
            'Unexpected sign-in step: ${result.nextStep.signInStep}';
        _authState = AuthState.signedOut;
      }
    } on AuthException catch (e) {
      _errorMessage = _mapAuthError(e);
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
    }
    notifyListeners();
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      devLog('Error signing out: $e');
    }
    _authState = AuthState.signedOut;
    _userEmail = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Get the current ID token for API requests
  Future<String?> getIdToken() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session is CognitoAuthSession) {
        return session.userPoolTokensResult.value.idToken.raw;
      }
    } catch (e) {
      devLog('Error fetching ID token: $e');
    }
    return null;
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Fetch user email from Cognito attributes
  Future<void> _fetchUserEmail() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      for (final attr in attributes) {
        if (attr.userAttributeKey.key == 'email') {
          _userEmail = attr.value;
          break;
        }
      }
    } catch (e) {
      devLog('Error fetching user email: $e');
    }
  }

  /// Map Amplify auth errors to user-friendly messages
  String _mapAuthError(AuthException e) {
    if (e is NotAuthorizedServiceException) {
      return 'Incorrect email or password.';
    } else if (e is UserNotFoundException) {
      return 'No account found with this email.';
    } else if (e is InvalidPasswordException) {
      return 'Password does not meet requirements.';
    } else if (e is TooManyRequestsException) {
      return 'Too many attempts. Please wait and try again.';
    } else if (e is UserNotConfirmedException) {
      return 'Account not confirmed. Please check your email.';
    } else {
      return e.message;
    }
  }
}
