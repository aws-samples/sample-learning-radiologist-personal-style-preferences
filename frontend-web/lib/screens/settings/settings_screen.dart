import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_settings.dart';
import '../../providers/cases_provider.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/error_messages.dart';
import '../../widgets/settings/clinical_interpretation_card.dart';
import '../../widgets/settings/data_source_card.dart';
import '../../widgets/settings/k_preferences_card.dart';
import '../../widgets/settings/model_selection_card.dart';
import '../../widgets/settings/reset_app_card.dart';
import '../onboarding/onboarding_dialog.dart';

/// Settings screen for user preferences
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return settingsAsync.when(
      data: (settings) => _buildContent(context, settings),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            const Text('Error loading settings'),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () =>
                  ref.read(settingsNotifierProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserSettings settings) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Configure generation behavior and preferences',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 32),

          // Getting Started Section
          _buildSection(
            context,
            title: 'Getting Started',
            description: 'Learn how to use the application.',
            child: _buildGettingStartedCard(context),
          ),
          const SizedBox(height: 24),

          // Data Source Section
          _buildSection(
            context,
            title: 'Data Source',
            description: 'Choose the source of radiology cases.',
            child: DataSourceCard(
              settings: settings,
              onChanged: _updateDataSource,
            ),
          ),
          const SizedBox(height: 24),

          // Model Selection Section
          _buildSection(
            context,
            title: 'Model Selection',
            description:
                'Choose which Claude model to use for each agent in the pipeline.',
            child: ModelSelectionCard(
              settings: settings,
              onChanged: _updateModelSettings,
            ),
          ),
          const SizedBox(height: 24),

          // Clinical Interpretation Section
          _buildSection(
            context,
            title: 'Clinical Interpretation',
            description:
                'Control how the AI interprets findings when generating impressions.',
            child: ClinicalInterpretationCard(
              settings: settings,
              onChanged: _updateClinicalInterpretation,
            ),
          ),
          const SizedBox(height: 24),

          // Preference Retrieval Section
          _buildSection(
            context,
            title: 'Preference Retrieval',
            description: 'Number of similar preferences to retrieve for each generation.',
            child: KPreferencesCard(
              settings: settings,
              onChanged: _updateKPreferences,
            ),
          ),
          const SizedBox(height: 24),

          // Reset App Section
          _buildSection(
            context,
            title: 'Reset App',
            description: 'Clear all data and restore default settings.',
            child: ResetAppCard(
              onReset: _resetApp,
              isResetting: _isSaving,
            ),
          ),

          // Saving indicator
          if (_isSaving) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildGettingStartedCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.play_circle_outline,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Show Introduction',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    'Re-watch the introduction walkthrough',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const OnboardingDialog(),
                );
              },
              child: const Text('Show'),
            ),
          ],
        ),
      ),
    );
  }

  /// Show a failure SnackBar after a settings update was rolled back.
  void _showUpdateError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not save setting: ${friendlyError(error)}')),
    );
  }

  Future<void> _updateClinicalInterpretation(bool value) async {
    if (!mounted) return;
    setState(() => _isSaving = true);
    try {
      // The notifier applies the change optimistically and rolls back on failure.
      await ref.read(settingsNotifierProvider.notifier).updateSettings(
            UpdateSettingsRequest(clinicalInterpretation: value),
          );
    } catch (e) {
      _showUpdateError(e);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _updateKPreferences(int value) async {
    if (!mounted) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(settingsNotifierProvider.notifier).updateSettings(
            UpdateSettingsRequest(kPreferences: value),
          );
    } catch (e) {
      _showUpdateError(e);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _updateModelSettings(ModelSettings modelSettings) async {
    if (!mounted) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(settingsNotifierProvider.notifier).updateSettings(
            UpdateSettingsRequest(modelSettings: modelSettings),
          );
    } catch (e) {
      _showUpdateError(e);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _updateDataSource(String dataSource, String? mimicBucket) async {
    if (!mounted) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(settingsNotifierProvider.notifier).updateSettings(
            UpdateSettingsRequest(
              dataSource: dataSource,
              mimicBucket: mimicBucket,
            ),
          );
      // Changing data source resets all data - refresh providers
      ref.invalidate(settingsNotifierProvider);
      ref.invalidate(casesProvider);
      ref.invalidate(preferencesProvider);
      ref.invalidate(rejectedPreferencesProvider);
    } catch (e) {
      _showUpdateError(e);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _resetApp() async {
    if (!mounted) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(settingsNotifierProvider.notifier).resetApp();
      // Refresh all providers
      ref.invalidate(settingsNotifierProvider);
      ref.invalidate(casesProvider);
      ref.invalidate(preferencesProvider);
      ref.invalidate(rejectedPreferencesProvider);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
