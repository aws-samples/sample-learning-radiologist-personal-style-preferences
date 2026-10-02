import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:report_preferences_web/widgets/settings/model_picker.dart';
import 'package:report_preferences_web/models/user_settings.dart';

/// Helper that wraps ModelPicker in the minimal scaffold needed for widget tests.
Widget _buildPicker({required String value, ValueChanged<String>? onChanged}) {
  return MaterialApp(
    home: Scaffold(
      body: ModelPicker(
        label: 'Test',
        description: 'Test description',
        value: value,
        onChanged: onChanged ?? (_) {},
      ),
    ),
  );
}

void main() {
  // ===========================================================================
  // ModelPicker - dropdown value resolution
  //
  // These tests catch the class of bug where a model upgrade changes the API
  // key (e.g. 'claude-sonnet-4.5' -> 'claude-sonnet-4.6') but the frontend
  // normalization map or dropdown item list is not updated in sync, causing a
  // blank / missing dropdown selection.
  // ===========================================================================

  group('ModelPicker value resolution', () {
    testWidgets('shows non-blank selection for current sonnet key', (tester) async {
      await tester.pumpWidget(_buildPicker(value: 'claude-sonnet-4.6'));

      // DropdownButton renders blank when value is not in items.
      // Verify the picker shows the short display name, not empty.
      expect(find.text('Sonnet 4.6'), findsOneWidget);
    });

    testWidgets('shows non-blank selection for backward-compat sonnet-4.5 key', (tester) async {
      await tester.pumpWidget(_buildPicker(value: 'claude-sonnet-4.5'));

      expect(find.text('Sonnet 4.6'), findsOneWidget);
    });

    testWidgets('shows non-blank selection for current opus key', (tester) async {
      await tester.pumpWidget(_buildPicker(value: 'claude-opus-4.8'));

      expect(find.text('Opus 4.8'), findsOneWidget);
    });

    testWidgets('shows current opus display for legacy opus key', (tester) async {
      // Legacy stored key resolves to the current Opus short name.
      await tester.pumpWidget(_buildPicker(value: 'claude-opus-4.6'));

      expect(find.text('Opus 4.8'), findsOneWidget);
    });

    testWidgets('shows non-blank selection for current haiku key', (tester) async {
      await tester.pumpWidget(_buildPicker(value: 'claude-haiku-4.5'));

      expect(find.text('Haiku 4.5'), findsOneWidget);
    });

    testWidgets('shows non-blank selection for short key sonnet', (tester) async {
      await tester.pumpWidget(_buildPicker(value: 'sonnet'));

      expect(find.text('Sonnet 4.6'), findsOneWidget);
    });
  });

  // ===========================================================================
  // ModelPicker - dropdown items
  //
  // Verifies all items in the dropdown match current model versions.
  // Catches stale hardcoded version strings in _getShortName.
  // ===========================================================================

  group('ModelPicker dropdown items', () {
    testWidgets('all three model options are present with correct version strings',
        (tester) async {
      await tester.pumpWidget(_buildPicker(value: 'sonnet'));

      // Open the dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // All three items should appear with correct version strings
      expect(find.text('Opus 4.8'), findsWidgets);
      expect(find.text('Sonnet 4.6'), findsWidgets);
      expect(find.text('Haiku 4.5'), findsWidgets);

      // Stale version strings must not appear
      expect(find.text('Sonnet 4.5'), findsNothing);
      expect(find.text('Opus 4.5'), findsNothing);
      expect(find.text('Opus 4.6'), findsNothing);
    });
  });

  // ===========================================================================
  // ModelPicker - AvailableModels consistency
  //
  // Unit-level checks that normalizeModelKey and the models map stay in sync.
  // Every API key that could be returned by the backend must normalize to a key
  // that exists in AvailableModels.models (otherwise the dropdown is blank).
  // ===========================================================================

  group('AvailableModels consistency - all API keys resolve to a dropdown item', () {
    final knownApiKeys = [
      'claude-opus-4.6',
      'claude-sonnet-4.6',
      'claude-haiku-4.5',
      // Backward compat keys
      'claude-opus-4.5',
      'claude-sonnet-4.5',
      // Short keys (already valid)
      'opus',
      'sonnet',
      'haiku',
    ];

    for (final apiKey in knownApiKeys) {
      test('$apiKey normalizes to a valid dropdown item', () {
        final normalized = AvailableModels.normalizeModelKey(apiKey);
        expect(
          AvailableModels.models.containsKey(normalized),
          isTrue,
          reason:
              '"$apiKey" normalized to "$normalized" which is not in AvailableModels.models. '
              'The dropdown will be blank. Update _apiToShort or AvailableModels.models.',
        );
      });
    }
  });
}
