import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'api_constants.dart';
import '../screens/cases/cases_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_shell.dart';
import '../screens/insights/insights_screen.dart';
import '../screens/preferences/preferences_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../services/auth_service.dart';

/// Route paths
class Routes {
  Routes._();

  static const String login = '/login';
  static const String cases = '/cases';
  static const String caseDetail = '/cases/:caseId';
  static const String preferences = '/preferences';
  static const String insights = '/insights';
  static const String settings = '/settings';
}

/// Creates the app router with auth redirect
GoRouter createRouter(AuthService authService) {
  return GoRouter(
    initialLocation: Routes.login,
    redirect: (context, state) {
      final isAuthenticated = authService.isAuthenticated;
      final isLoading = authService.authState == AuthState.loading;
      final isOnLoginPage = state.matchedLocation == Routes.login;

      // During loading, stay on current page (login page initially)
      if (isLoading) {
        return isOnLoginPage ? null : Routes.login;
      }

      // Redirect to login if not authenticated
      if (!isAuthenticated && !isOnLoginPage) {
        return Routes.login;
      }

      // Redirect away from login if authenticated
      if (isAuthenticated && isOnLoginPage) {
        return Routes.cases;
      }

      return null;
    },
    refreshListenable: authService,
    routes: [
      // Login route (outside shell)
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      // Main shell with navigation rail
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: Routes.cases,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              transitionDuration: const Duration(milliseconds: TimingConstants.standardTransitionMs),
              child: const CasesScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: Routes.caseDetail,
            pageBuilder: (context, state) {
              final caseId = state.pathParameters['caseId']!;
              return CustomTransitionPage(
                key: state.pageKey,
                transitionDuration: const Duration(milliseconds: TimingConstants.standardTransitionMs),
                child: CasesScreen(initialCaseId: caseId),
                transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
              );
            },
          ),
          GoRoute(
            path: Routes.preferences,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              transitionDuration: const Duration(milliseconds: TimingConstants.standardTransitionMs),
              child: const PreferencesScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: Routes.insights,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              transitionDuration: const Duration(milliseconds: TimingConstants.standardTransitionMs),
              child: const InsightsScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: Routes.settings,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              transitionDuration: const Duration(milliseconds: TimingConstants.standardTransitionMs),
              child: const SettingsScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.matchedLocation}'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(Routes.cases),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
