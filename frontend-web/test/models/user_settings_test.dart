import 'package:flutter_test/flutter_test.dart';
import 'package:report_preferences_web/models/user_settings.dart';

void main() {
  // ============================================================================
  // ModelSettings
  // ============================================================================

  group('ModelSettings deserialization', () {
    test('should deserialize all agent model keys from backend', () {
      final json = {
        'base_impression': 'opus',
        'style_refinement': 'sonnet',
        'preference_inference': 'sonnet',
        'preference_validator': 'haiku',
        'preference_edit_validator': 'haiku',
      };

      final settings = ModelSettings.fromJson(json);

      expect(settings.baseImpression, 'opus');
      expect(settings.styleRefinement, 'sonnet');
      expect(settings.preferenceInference, 'sonnet');
      expect(settings.preferenceValidator, 'haiku');
      expect(settings.preferenceEditValidator, 'haiku');
    });

    test('should default all agents to expected models', () {
      final settings = ModelSettings.fromJson(<String, dynamic>{});

      expect(settings.baseImpression, 'sonnet');
      expect(settings.styleRefinement, 'sonnet');
      expect(settings.preferenceInference, 'sonnet');
      expect(settings.preferenceValidator, 'haiku');
      expect(settings.preferenceEditValidator, 'haiku');
    });

    test('toJson should produce snake_case keys', () {
      const settings = ModelSettings(
        baseImpression: 'opus',
        styleRefinement: 'opus',
        preferenceInference: 'sonnet',
        preferenceValidator: 'haiku',
        preferenceEditValidator: 'haiku',
      );

      final json = settings.toJson();

      expect(json['base_impression'], 'opus');
      expect(json['style_refinement'], 'opus');
      expect(json['preference_inference'], 'sonnet');
      expect(json['preference_validator'], 'haiku');
      expect(json['preference_edit_validator'], 'haiku');
    });
  });

  // ============================================================================
  // UserSettings
  // ============================================================================

  group('UserSettings deserialization', () {
    test('should deserialize full settings from backend', () {
      final json = {
        'clinical_interpretation': true,
        'model_settings': {
          'base_impression': 'opus',
          'style_refinement': 'sonnet',
          'preference_inference': 'sonnet',
          'preference_validator': 'haiku',
          'preference_edit_validator': 'haiku',
        },
        'k_preferences': 15,
        'data_source': 'mimic',
        'mimic_bucket': 'my-mimic-bucket',
      };

      final settings = UserSettings.fromJson(json);

      expect(settings.clinicalInterpretation, isTrue);
      expect(settings.modelSettings.baseImpression, 'opus');
      expect(settings.kPreferences, 15);
      expect(settings.dataSource, 'mimic');
      expect(settings.mimicBucket, 'my-mimic-bucket');
    });

    test('should default to safe values', () {
      final settings = UserSettings.fromJson(<String, dynamic>{});

      expect(settings.clinicalInterpretation, isTrue); // default ON
      expect(settings.modelSettings.baseImpression, 'sonnet');
      expect(settings.kPreferences, 10);
      expect(settings.dataSource, 'synthetic');
      expect(settings.mimicBucket, isNull);
    });

    test('should handle partial model_settings', () {
      final json = {
        'model_settings': {
          'base_impression': 'opus',
          // Other fields missing — should use defaults
        },
      };

      final settings = UserSettings.fromJson(json);

      expect(settings.modelSettings.baseImpression, 'opus');
      expect(settings.modelSettings.preferenceValidator, 'haiku');
    });
  });

  // ============================================================================
  // UpdateSettingsRequest
  // ============================================================================

  group('UpdateSettingsRequest', () {
    test('toJson should produce snake_case keys', () {
      const req = UpdateSettingsRequest(
        clinicalInterpretation: true,
        kPreferences: 20,
        dataSource: 'mimic',
        mimicBucket: 'bucket-name',
      );

      final json = req.toJson();

      expect(json['clinical_interpretation'], isTrue);
      expect(json['k_preferences'], 20);
      expect(json['data_source'], 'mimic');
      expect(json['mimic_bucket'], 'bucket-name');
    });

    test('toJson should omit null fields (includeIfNull: false)', () {
      const req = UpdateSettingsRequest(
        clinicalInterpretation: false,
      );

      final json = req.toJson();

      expect(json['clinical_interpretation'], isFalse);
      // Null fields should not be present in JSON
      expect(json.containsKey('k_preferences'), isFalse);
      expect(json.containsKey('data_source'), isFalse);
      expect(json.containsKey('mimic_bucket'), isFalse);
      expect(json.containsKey('model_settings'), isFalse);
    });

    test('toJson should include model_settings when provided', () {
      const req = UpdateSettingsRequest(
        modelSettings: ModelSettings(
          baseImpression: 'opus',
          styleRefinement: 'opus',
        ),
      );

      final json = req.toJson();

      expect(json.containsKey('model_settings'), isTrue);
      // Freezed may keep the nested object; verify via the ModelSettings API
      final ms = json['model_settings'];
      if (ms is Map<String, dynamic>) {
        expect(ms['base_impression'], 'opus');
        expect(ms['style_refinement'], 'opus');
      } else {
        // Freezed preserved the object — verify fields directly
        expect((ms as ModelSettings).baseImpression, 'opus');
        expect(ms.styleRefinement, 'opus');
      }
    });
  });

  // ============================================================================
  // UpdateSettingsResponse
  // ============================================================================

  group('UpdateSettingsResponse deserialization', () {
    test('should deserialize with data_reset info', () {
      final json = {
        'success': true,
        'message': 'Settings updated. Data reloaded.',
        'data_reset': true,
        'cases_loaded': 25,
      };

      final response = UpdateSettingsResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, contains('reloaded'));
      expect(response.dataReset, isTrue);
      expect(response.casesLoaded, 25);
    });

    test('should handle simple success without data_reset', () {
      final json = {
        'success': true,
        'message': 'OK',
      };

      final response = UpdateSettingsResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.dataReset, isNull);
      expect(response.casesLoaded, isNull);
    });
  });

  // ============================================================================
  // AvailableModels utility
  // ============================================================================

  group('AvailableModels.normalizeModelKey', () {
    test('should return short keys unchanged', () {
      expect(AvailableModels.normalizeModelKey('opus'), 'opus');
      expect(AvailableModels.normalizeModelKey('sonnet'), 'sonnet');
      expect(AvailableModels.normalizeModelKey('haiku'), 'haiku');
    });

    test('should convert API format to short key', () {
      expect(AvailableModels.normalizeModelKey('claude-opus-4.6'), 'opus');
      expect(AvailableModels.normalizeModelKey('claude-sonnet-4.6'), 'sonnet');
      expect(AvailableModels.normalizeModelKey('claude-haiku-4.5'), 'haiku');
    });

    test('should handle backward-compat opus-4.5 -> opus', () {
      expect(AvailableModels.normalizeModelKey('claude-opus-4.5'), 'opus');
    });

    test('should handle backward-compat sonnet-4.5 -> sonnet', () {
      expect(AvailableModels.normalizeModelKey('claude-sonnet-4.5'), 'sonnet');
    });

    test('should return unknown keys as-is', () {
      expect(
        AvailableModels.normalizeModelKey('claude-unknown-9.9'),
        'claude-unknown-9.9',
      );
    });
  });

  group('AvailableModels.displayName', () {
    test('should map short keys to display names', () {
      expect(AvailableModels.displayName('opus'), 'Claude Opus 4.8');
      expect(AvailableModels.displayName('sonnet'), 'Claude Sonnet 4.6');
      expect(AvailableModels.displayName('haiku'), 'Claude Haiku 4.5');
    });

    test('should map API format keys to display names', () {
      // claude-opus-4.6 is a legacy alias -> opus -> current Opus display
      expect(AvailableModels.displayName('claude-opus-4.6'), 'Claude Opus 4.8');
      expect(AvailableModels.displayName('claude-sonnet-4.6'), 'Claude Sonnet 4.6');
      expect(AvailableModels.displayName('claude-haiku-4.5'), 'Claude Haiku 4.5');
    });

    test('should return unknown keys as-is', () {
      expect(
        AvailableModels.displayName('claude-mystery-1.0'),
        'claude-mystery-1.0',
      );
    });
  });

  // ============================================================================
  // DataSource enum
  // ============================================================================

  group('DataSource enum', () {
    test('should have synthetic and mimic values', () {
      expect(DataSource.values, contains(DataSource.synthetic));
      expect(DataSource.values, contains(DataSource.mimic));
      expect(DataSource.values, hasLength(2));
    });
  });
}
