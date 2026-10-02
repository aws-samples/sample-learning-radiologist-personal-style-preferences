import 'package:flutter_test/flutter_test.dart';
import 'package:report_preferences_web/models/case.dart';

void main() {
  // ============================================================================
  // Case
  // ============================================================================

  group('Case deserialization', () {
    test('should deserialize from backend JSON with snake_case keys', () {
      final json = {
        'case_id': 'Case_001',
        'findings': 'No acute cardiopulmonary abnormality.',
        'has_generated': true,
        'has_edited': false,
      };

      final c = Case.fromJson(json);

      expect(c.caseId, 'Case_001');
      expect(c.findings, 'No acute cardiopulmonary abnormality.');
      expect(c.hasGenerated, isTrue);
      expect(c.hasEdited, isFalse);
    });

    test('should default missing fields', () {
      final json = <String, dynamic>{};

      final c = Case.fromJson(json);

      expect(c.caseId, '');
      expect(c.findings, '');
      expect(c.hasGenerated, isFalse);
      expect(c.hasEdited, isFalse);
    });

    test('toJson should produce snake_case keys', () {
      const c = Case(
        caseId: 'Case_002',
        findings: 'Mild cardiomegaly.',
        hasGenerated: true,
        hasEdited: true,
      );

      final json = c.toJson();

      expect(json['case_id'], 'Case_002');
      expect(json['has_generated'], isTrue);
      expect(json['has_edited'], isTrue);
    });
  });

  // ============================================================================
  // CasesResponse
  // ============================================================================

  group('CasesResponse deserialization', () {
    test('should deserialize list of cases from backend', () {
      final json = {
        'count': 2,
        'cases': [
          {
            'case_id': 'Case_001',
            'findings': 'Finding A',
            'has_generated': false,
            'has_edited': false,
          },
          {
            'case_id': 'Case_002',
            'findings': 'Finding B',
            'has_generated': true,
            'has_edited': true,
          },
        ],
      };

      final response = CasesResponse.fromJson(json);

      expect(response.count, 2);
      expect(response.cases, hasLength(2));
      expect(response.cases[0].caseId, 'Case_001');
      expect(response.cases[1].hasGenerated, isTrue);
    });

    test('should handle empty cases list', () {
      final json = {
        'count': 0,
        'cases': <Map<String, dynamic>>[],
      };

      final response = CasesResponse.fromJson(json);

      expect(response.count, 0);
      expect(response.cases, isEmpty);
    });

    test('should default when keys are missing', () {
      final json = <String, dynamic>{};

      final response = CasesResponse.fromJson(json);

      expect(response.count, 0);
      expect(response.cases, isEmpty);
    });
  });

  // ============================================================================
  // CaseAppliedPreference
  // ============================================================================

  group('CaseAppliedPreference deserialization', () {
    test('should deserialize from backend JSON', () {
      final json = {
        'preference_id': 'pref_abc123',
        'preference_text': 'Use bullet points for impressions',
      };

      final pref = CaseAppliedPreference.fromJson(json);

      expect(pref.preferenceId, 'pref_abc123');
      expect(pref.preferenceText, 'Use bullet points for impressions');
    });

    test('should default to empty strings', () {
      final pref = CaseAppliedPreference.fromJson(<String, dynamic>{});

      expect(pref.preferenceId, '');
      expect(pref.preferenceText, '');
    });
  });

  // ============================================================================
  // CaseImageUrl
  // ============================================================================

  group('CaseImageUrl deserialization', () {
    test('should deserialize with all fields', () {
      final json = {
        'view': 'frontal',
        'url': 'https://s3.example.com/image.dcm',
        'expires_at': 1700000000.0,
      };

      final img = CaseImageUrl.fromJson(json);

      expect(img.view, 'frontal');
      expect(img.url, 'https://s3.example.com/image.dcm');
      expect(img.expiresAt, 1700000000.0);
    });

    test('should handle missing optional expires_at', () {
      final json = {
        'view': 'lateral',
        'url': 'https://example.com/img.png',
      };

      final img = CaseImageUrl.fromJson(json);

      expect(img.view, 'lateral');
      expect(img.expiresAt, isNull);
    });
  });

  // ============================================================================
  // CaseEditHistoryEntry
  // ============================================================================

  group('CaseEditHistoryEntry deserialization', () {
    test('should deserialize full entry from backend', () {
      final json = {
        'edit_id': 'edit_abc123',
        'original_impression': 'No acute findings.',
        'edited_impression': '• No acute findings.',
        'edit_distance': 0.15,
        'timestamp': 1700000000.0,
        'source': 'user_edit',
        'preferences_snapshot': [
          {
            'preference_id': 'pref_001',
            'preference_text': 'Use bullet points',
          },
        ],
      };

      final entry = CaseEditHistoryEntry.fromJson(json);

      expect(entry.editId, 'edit_abc123');
      expect(entry.originalImpression, 'No acute findings.');
      expect(entry.editedImpression, '• No acute findings.');
      expect(entry.editDistance, closeTo(0.15, 0.001));
      expect(entry.timestamp, 1700000000.0);
      expect(entry.source, 'user_edit');
      expect(entry.preferencesSnapshot, hasLength(1));
      expect(entry.preferencesSnapshot![0].preferenceText, 'Use bullet points');
    });

    test('should default source to unknown', () {
      final json = {
        'edit_id': 'edit_001',
        'timestamp': 1700000000.0,
      };

      final entry = CaseEditHistoryEntry.fromJson(json);

      expect(entry.source, 'unknown');
    });

    test('should handle null preferences_snapshot', () {
      final json = {
        'edit_id': 'edit_002',
        'timestamp': 1700000000.0,
      };

      final entry = CaseEditHistoryEntry.fromJson(json);

      expect(entry.preferencesSnapshot, isNull);
    });
  });

  // ============================================================================
  // CaseDetail — JSON deserialization
  // ============================================================================

  group('CaseDetail deserialization', () {
    test('should deserialize full case detail from backend', () {
      final json = {
        'case_id': 'Case_005',
        'findings': 'Mild cardiomegaly.',
        'reference_impression': 'Reference text.',
        'generated_impression': 'Generated text.',
        'edited_impression': 'Edited text.',
        'generated_at': 1700000000.0,
        'edited_at': 1700000100.0,
        'base_impression': 'Base text.',
        'base_impression_model': 'us.anthropic.claude-sonnet-4-5-v1',
        'refinement_model': 'us.anthropic.claude-sonnet-4-5-v1',
        'preferences_applied': [
          {'preference_id': 'p1', 'preference_text': 'Be concise'},
        ],
        'edit_history': [
          {
            'edit_id': 'edit_001',
            'original_impression': 'Original.',
            'edited_impression': 'Edited.',
            'edit_distance': 0.2,
            'timestamp': 1700000050.0,
            'source': 'user_edit',
          },
        ],
        'image_urls': [
          {
            'view': 'frontal',
            'url': 'https://example.com/img.png',
          },
        ],
      };

      final detail = CaseDetail.fromJson(json);

      expect(detail.caseId, 'Case_005');
      expect(detail.findings, 'Mild cardiomegaly.');
      expect(detail.referenceImpression, 'Reference text.');
      expect(detail.generatedImpression, 'Generated text.');
      expect(detail.editedImpression, 'Edited text.');
      expect(detail.baseImpression, 'Base text.');
      expect(detail.preferencesApplied, hasLength(1));
      expect(detail.editHistory, hasLength(1));
      expect(detail.imageUrls, hasLength(1));
    });

    test('should handle minimal case detail (new case)', () {
      final json = {
        'case_id': 'Case_010',
        'findings': 'Normal chest X-ray.',
      };

      final detail = CaseDetail.fromJson(json);

      expect(detail.caseId, 'Case_010');
      expect(detail.generatedImpression, isNull);
      expect(detail.editedImpression, isNull);
      expect(detail.referenceImpression, isNull);
      expect(detail.preferencesApplied, isNull);
      expect(detail.editHistory, isNull);
      expect(detail.imageUrls, isNull);
    });
  });

  // ============================================================================
  // CaseDetail — Computed Properties
  // ============================================================================

  group('CaseDetail.currentImpression', () {
    test('should return editedImpression when all three exist', () {
      const detail = CaseDetail(
        caseId: 'c1',
        findings: 'f',
        referenceImpression: 'reference',
        generatedImpression: 'generated',
        editedImpression: 'edited',
      );

      expect(detail.currentImpression, 'edited');
    });

    test('should return generatedImpression when no edit exists', () {
      const detail = CaseDetail(
        caseId: 'c2',
        findings: 'f',
        referenceImpression: 'reference',
        generatedImpression: 'generated',
      );

      expect(detail.currentImpression, 'generated');
    });

    test('should return referenceImpression when nothing generated', () {
      const detail = CaseDetail(
        caseId: 'c3',
        findings: 'f',
        referenceImpression: 'reference',
      );

      expect(detail.currentImpression, 'reference');
    });

    test('should return null when nothing exists', () {
      const detail = CaseDetail(caseId: 'c4', findings: 'f');

      expect(detail.currentImpression, isNull);
    });

    test('should skip null generatedImpression and use reference', () {
      const detail = CaseDetail(
        caseId: 'c5',
        findings: 'f',
        referenceImpression: 'reference',
        editedImpression: null,
        generatedImpression: null,
      );

      expect(detail.currentImpression, 'reference');
    });
  });

  group('CaseDetail.wasEdited', () {
    test('should be true when both edited and generated exist', () {
      const detail = CaseDetail(
        caseId: 'c1',
        findings: 'f',
        generatedImpression: 'generated',
        editedImpression: 'edited',
      );

      expect(detail.wasEdited, isTrue);
    });

    test('should be false when only generated exists', () {
      const detail = CaseDetail(
        caseId: 'c2',
        findings: 'f',
        generatedImpression: 'generated',
      );

      expect(detail.wasEdited, isFalse);
    });

    test('should be false when neither exists', () {
      const detail = CaseDetail(caseId: 'c3', findings: 'f');

      expect(detail.wasEdited, isFalse);
    });

    test('should be false when only edited exists (edge case)', () {
      // This shouldn't happen in practice — you can't edit without generating.
      // But the computed property checks both fields.
      const detail = CaseDetail(
        caseId: 'c4',
        findings: 'f',
        editedImpression: 'edited',
      );

      expect(detail.wasEdited, isFalse);
    });
  });

  group('CaseDetail.hasGenerated', () {
    test('should be true when generated impression exists', () {
      const detail = CaseDetail(
        caseId: 'c1',
        findings: 'f',
        generatedImpression: 'generated',
      );

      expect(detail.hasGenerated, isTrue);
    });

    test('should be false when generated impression is null', () {
      const detail = CaseDetail(caseId: 'c2', findings: 'f');

      expect(detail.hasGenerated, isFalse);
    });
  });
}
