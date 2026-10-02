import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/preference.dart';
import '../../providers/api_provider.dart';
import '../../providers/preferences_provider.dart';
import '../../utils/error_messages.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/preferences/preference_row.dart';
import '../../widgets/preferences/rejected_preference_row.dart';
import '../../widgets/preferences/sort_chip.dart';

/// Preferences screen with learned and rejected tabs
class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(preferencesTabProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(color: colorScheme.outlineVariant),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preferences',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Style preferences learned from your edits',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 16),
              // Tabs
              Row(
                children: [
                  _TabButton(
                    label: 'Learned',
                    icon: Icons.check_circle_outline,
                    isSelected: currentTab == PreferencesTab.learned,
                    onTap: () => ref.read(preferencesTabProvider.notifier).state =
                        PreferencesTab.learned,
                  ),
                  const SizedBox(width: 8),
                  _TabButton(
                    label: 'Rejected',
                    icon: Icons.block_outlined,
                    isSelected: currentTab == PreferencesTab.rejected,
                    onTap: () => ref.read(preferencesTabProvider.notifier).state =
                        PreferencesTab.rejected,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Search and sort
              Row(
                children: [
                  Expanded(
                    child: SearchField(
                      hintText: 'Search preferences...',
                      provider: preferenceSearchProvider,
                    ),
                  ),
                  if (currentTab == PreferencesTab.learned) ...[
                    const SizedBox(width: 16),
                    const _SortChips(),
                  ],
                ],
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: currentTab == PreferencesTab.learned
              ? const _LearnedPreferencesView()
              : const _RejectedPreferencesView(),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color:
          isSelected ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortChips extends ConsumerWidget {
  const _SortChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(preferenceSortProvider);

    return Row(
      children: [
        PreferenceSortChip(
          label: 'Recent',
          icon: Icons.schedule,
          isSelected: currentSort == PreferenceSort.recent,
          onTap: () => ref.read(preferenceSortProvider.notifier).state =
              PreferenceSort.recent,
        ),
        const SizedBox(width: 8),
        PreferenceSortChip(
          label: 'Category',
          icon: Icons.category_outlined,
          isSelected: currentSort == PreferenceSort.category,
          onTap: () => ref.read(preferenceSortProvider.notifier).state =
              PreferenceSort.category,
        ),
        const SizedBox(width: 8),
        PreferenceSortChip(
          label: 'Confidence',
          icon: Icons.trending_up,
          isSelected: currentSort == PreferenceSort.confidence,
          onTap: () => ref.read(preferenceSortProvider.notifier).state =
              PreferenceSort.confidence,
        ),
      ],
    );
  }
}

class _LearnedPreferencesView extends ConsumerWidget {
  const _LearnedPreferencesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(sortedPreferencesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return prefsAsync.when(
      data: (prefs) {
        if (prefs.isEmpty) {
          return _buildEmptyState(context, 'No preferences learned yet');
        }

        return RefreshIndicator(
          onRefresh: () => ref.refresh(preferencesProvider.future),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: prefs.length,
            itemBuilder: (context, index) {
              return PreferenceRow(
                preference: prefs[index],
                onDelete: () => _deletePreference(ref, prefs[index]),
                onEdit: (newText) => _editPreference(ref, prefs[index], newText),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            const Text('Error loading preferences'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                friendlyError(error),
                style: TextStyle(fontSize: 12, color: colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => ref.invalidate(preferencesProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deletePreference(WidgetRef ref, Preference pref) async {
    try {
      final apiService = ref.read(apiServiceProvider);
      await apiService.deletePreference(pref.preferenceId);
      ref.invalidate(preferencesProvider);
    } catch (e) {
      // Error handling would go here
    }
  }

  /// Edit a preference. Returns error message on failure, null on success.
  Future<String?> _editPreference(
    WidgetRef ref,
    Preference pref,
    String newText,
  ) async {
    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.updatePreference(
        pref.preferenceId,
        newText,
      );
      if (response.success) {
        ref.invalidate(preferencesProvider);
        return null;
      } else {
        // Use message for error details, or safetyWarning for safety rejections
        return response.safetyWarning ?? response.message ?? 'Failed to update preference';
      }
    } catch (e) {
      // friendlyError prefers the backend's curated {error:{message}} envelope
      // and otherwise returns a safe, PHI-free message.
      return friendlyError(e);
    }
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.tune_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Edit generated impressions to teach the system\nyour style preferences.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RejectedPreferencesView extends ConsumerWidget {
  const _RejectedPreferencesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(sortedRejectedPreferencesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return prefsAsync.when(
      data: (prefs) {
        if (prefs.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: () => ref.refresh(rejectedPreferencesProvider.future),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: prefs.length,
            itemBuilder: (context, index) {
              return RejectedPreferenceRow(preference: prefs[index]);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            const Text('Error loading rejected preferences'),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () => ref.invalidate(rejectedPreferencesProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No rejected changes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Changes that are flagged as unsafe will appear here\nfor transparency.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
