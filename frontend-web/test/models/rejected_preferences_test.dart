import 'package:flutter_test/flutter_test.dart';
import 'package:report_preferences_web/models/preference.dart';

/// Regression tests for RejectedPreference and RejectedPreferencesResponse
/// deserialization from the GET /preferences/rejected endpoint.
void main() {
  group('RejectedPreference deserialization', () {
    test('should deserialize all fields from backend JSON', () {
      final json = {
        'rejection_id': 'rej_1700000000_abc12345',
        'change_description': 'Added differential diagnosis',
        'rejection_reason': 'Content-adding: clinical interpretation not allowed',
        'rejection_layer': 'keyword_filter',
        'source_case_id': 'Case_001',
        'timestamp': 1700000000.0,
        'risk_level': 'high',
        'inference_model': 'us.anthropic.claude-sonnet-4-5-v1',
      };

      final pref = RejectedPreference.fromJson(json);

      expect(pref.rejectionId, 'rej_1700000000_abc12345');
      expect(pref.changeDescription, 'Added differential diagnosis');
      expect(pref.rejectionReason, 'Content-adding: clinical interpretation not allowed');
      expect(pref.rejectionLayer, 'keyword_filter');
      expect(pref.sourceCaseId, 'Case_001');
      expect(pref.timestamp, 1700000000.0);
      expect(pref.riskLevel, 'high');
      expect(pref.inferenceModel, 'us.anthropic.claude-sonnet-4-5-v1');
    });

    test('should handle missing optional fields', () {
      final json = {
        'rejection_id': 'rej_001',
        'change_description': 'Some change',
        'rejection_reason': 'Some reason',
        'rejection_layer': 'validator_agent',
        'source_case_id': 'Case_002',
        'timestamp': 1700000000.0,
      };

      final pref = RejectedPreference.fromJson(json);

      expect(pref.riskLevel, isNull);
      expect(pref.inferenceModel, isNull);
    });
  });

  group('RejectedPreferencesResponse deserialization', () {
    test('should deserialize from backend GET /preferences/rejected response', () {
      // This is the exact JSON shape from the Lambda's get_rejected_preferences()
      final json = {
        'count': 2,
        'rejected_preferences': [
          {
            'rejection_id': 'rej_001',
            'change_description': 'Added diagnosis',
            'rejection_reason': 'Content-adding keyword: diagnosis',
            'rejection_layer': 'keyword_filter',
            'source_case_id': 'Case_001',
            'timestamp': 1700000002.0,
          },
          {
            'rejection_id': 'rej_002',
            'change_description': 'Suggested follow-up',
            'rejection_reason': 'Validator rejected: adds clinical recommendation',
            'rejection_layer': 'validator_agent',
            'source_case_id': 'Case_002',
            'timestamp': 1700000001.0,
            'risk_level': 'medium',
          },
        ],
      };

      final response = RejectedPreferencesResponse.fromJson(json);

      expect(response.count, 2);
      expect(response.rejectedPreferences, hasLength(2));
      expect(response.rejectedPreferences[0].rejectionReason,
          'Content-adding keyword: diagnosis');
      expect(response.rejectedPreferences[1].riskLevel, 'medium');
    });

    test('should handle empty rejected_preferences list', () {
      final json = {
        'count': 0,
        'rejected_preferences': <Map<String, dynamic>>[],
      };

      final response = RejectedPreferencesResponse.fromJson(json);

      expect(response.count, 0);
      expect(response.rejectedPreferences, isEmpty);
    });
  });
}
