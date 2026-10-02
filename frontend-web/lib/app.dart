import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'config/app_theme.dart';
import 'config/routes.dart';
import 'providers/auth_provider.dart';

/// Provider for the GoRouter instance (cached, not recreated on rebuild)
final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);
  return createRouter(authService);
});

/// Main application widget
class ReportPreferencesApp extends ConsumerStatefulWidget {
  const ReportPreferencesApp({super.key});

  @override
  ConsumerState<ReportPreferencesApp> createState() =>
      _ReportPreferencesAppState();
}

class _ReportPreferencesAppState extends ConsumerState<ReportPreferencesApp> {
  @override
  void initState() {
    super.initState();
    // Check auth status on app start
    Future.microtask(() {
      ref.read(authServiceProvider).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Report Preferences',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
