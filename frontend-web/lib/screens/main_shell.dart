import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../config/app_theme.dart';
import '../config/routes.dart';
import '../providers/auth_provider.dart';
import '../providers/cases_provider.dart';
import '../providers/local_storage_provider.dart';
import '../providers/preferences_provider.dart';
import '../providers/settings_provider.dart';
import 'onboarding/onboarding_dialog.dart';

/// Main shell with navigation rail and app bar
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;
  bool _hasShownOnboarding = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update selected index based on current route
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/cases')) {
      _selectedIndex = 0;
    } else if (location == '/preferences') {
      _selectedIndex = 1;
    } else if (location == '/insights') {
      _selectedIndex = 2;
    } else if (location == '/settings') {
      _selectedIndex = 3;
    }

    // Check if we should show onboarding (when preferences are empty)
    _checkOnboarding();
  }

  void _checkOnboarding() {
    if (_hasShownOnboarding) return;

    // Check persisted flag — skip if already shown in a previous session
    final localPrefs = ref.read(sharedPreferencesProvider);
    if (localPrefs.getBool(kOnboardingShownKey) ?? false) {
      _hasShownOnboarding = true;
      return;
    }

    // No persisted flag → first-time user (or data was reset by ref.listen below).
    _hasShownOnboarding = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showOnboarding();
    });
  }

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
    // Clear new-preferences badge when navigating to Preferences
    if (index == 1) {
      ref.read(hasNewPreferencesProvider.notifier).state = false;
      ref.read(sharedPreferencesProvider).remove(kHasNewPreferencesKey);
    }
    switch (index) {
      case 0:
        context.go(Routes.cases);
        break;
      case 1:
        context.go(Routes.preferences);
        break;
      case 2:
        context.go(Routes.insights);
        break;
      case 3:
        context.go(Routes.settings);
        break;
    }
  }

  void _showOnboarding() {
    // Persist that onboarding has been shown
    ref.read(sharedPreferencesProvider).setBool(kOnboardingShownKey, true);
    showDialog(
      context: context,
      builder: (context) => const OnboardingDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the reactive view so the avatar/email update when the user's
    // attributes load asynchronously after sign-in.
    final authService = ref.watch(authChangeProvider);
    final userInitials = authService.userInitials;
    final userEmail = authService.userEmail;
    final colorScheme = Theme.of(context).colorScheme;

    // Listen for preferences changes to show onboarding when empty (e.g., after data reset)
    ref.listen<AsyncValue<List>>(preferencesProvider, (previous, next) {
      // Check if preferences changed from non-empty to empty (data reset)
      final wasNonEmpty = previous?.valueOrNull?.isNotEmpty ?? false;
      final isNowEmpty = next.valueOrNull?.isEmpty ?? false;

      if (wasNonEmpty && isNowEmpty) {
        // Data was reset - allow onboarding to show again after a delay
        // (wait for new data to potentially load)
        _hasShownOnboarding = false;
        ref.read(sharedPreferencesProvider).remove(kOnboardingShownKey);
        Future.delayed(const Duration(seconds: 2), () {
          // Re-check if still empty after delay
          final currentPrefs = ref.read(preferencesProvider);
          currentPrefs.whenData((prefs) {
            if (prefs.isEmpty && !_hasShownOnboarding && mounted) {
              _hasShownOnboarding = true;
              _showOnboarding();
            }
          });
        });
      }
    });

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.digit1, control: true): () =>
            _onDestinationSelected(0),
        const SingleActivator(LogicalKeyboardKey.digit2, control: true): () =>
            _onDestinationSelected(1),
        const SingleActivator(LogicalKeyboardKey.digit3, control: true): () =>
            _onDestinationSelected(2),
        const SingleActivator(LogicalKeyboardKey.digit4, control: true): () =>
            _onDestinationSelected(3),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: Row(
            children: [
              // Navigation Rail
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onDestinationSelected,
                labelType: NavigationRailLabelType.all,
                minWidth: 80,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      // App logo — teal gradient circle with RP monogram
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.teal,
                              Color(0xFF00695C),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.teal.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'RP',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                trailing: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Help button
                      IconButton(
                        icon: Icon(
                          Icons.help_outline,
                          color: Colors.white.withValues(alpha: 0.65),
                        ),
                        tooltip: 'Show Introduction',
                        onPressed: _showOnboarding,
                      ),
                      const SizedBox(height: 8),
                      // User profile
                      PopupMenuButton<String>(
                        tooltip: 'Account',
                        offset: const Offset(60, 0),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: Text(
                            userInitials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            enabled: false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userEmail ?? 'Unknown',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  'Signed in',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem(
                            value: 'signout',
                            child: Row(
                              children: [
                                Icon(Icons.logout),
                                SizedBox(width: 8),
                                Text('Sign Out'),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'signout') {
                            // Sign out first to clear the session, then
                            // invalidate providers. Using .then() ensures
                            // invalidation runs after session teardown
                            // regardless of whether the shell is still mounted.
                            authService.signOut().then((_) {
                              ref.invalidate(casesProvider);
                              ref.invalidate(caseDetailProvider);
                              ref.invalidate(preferencesProvider);
                              ref.invalidate(rejectedPreferencesProvider);
                              ref.invalidate(settingsProvider);
                              ref.invalidate(settingsNotifierProvider);
                            });
                            ref.read(selectedCaseIdProvider.notifier).state = null;
                            ref.read(hasNewPreferencesProvider.notifier).state = false;
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                destinations: [
                  const NavigationRailDestination(
                    icon: Icon(Icons.folder_outlined),
                    selectedIcon: Icon(Icons.folder),
                    label: Text('Cases'),
                  ),
                  NavigationRailDestination(
                    icon: Badge(
                      isLabelVisible: ref.watch(hasNewPreferencesProvider),
                      child: const Icon(Icons.tune_outlined),
                    ),
                    selectedIcon: Badge(
                      isLabelVisible: ref.watch(hasNewPreferencesProvider),
                      child: const Icon(Icons.tune),
                    ),
                    label: const Text('Preferences'),
                  ),
                  const NavigationRailDestination(
                    icon: Icon(Icons.insights_outlined),
                    selectedIcon: Icon(Icons.insights),
                    label: Text('Insights'),
                  ),
                  const NavigationRailDestination(
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                ],
              ),
              // Main content
              Expanded(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}
