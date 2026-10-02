import 'package:flutter_test/flutter_test.dart';
import 'package:report_preferences_web/models/api_models.dart';

/// Tests for API model JSON deserialization.
///
/// These tests ensure the Dart freezed models correctly map to the JSON keys
/// produced by the Python backend (Pydantic models). A key mismatch means the
/// frontend silently receives default/empty values.
void main() {
  // ============================================================================
  // GenerateRequest
  // ============================================================================

  group('GenerateRequest', () {
    test('toJson should produce snake_case keys', () {
      const req = GenerateRequest(
        caseId: 'Case_001',
        findings: 'Normal chest X-ray.',
        clinicalInterpretation: true,
        idempotencyKey: 'test-uuid-generate',
      );

      final json = req.toJson();

      expect(json['case_id'], 'Case_001');
      expect(json['findings'], 'Normal chest X-ray.');
      expect(json['clinical_interpretation'], isTrue);
    });

    test('clinicalInterpretation should default to false', () {
      const req = GenerateRequest(
        caseId: 'Case_001',
        findings: 'Findings.',
        idempotencyKey: 'test-uuid-generate',
      );

      expect(req.clinicalInterpretation, isFalse);
      expect(req.toJson()['clinical_interpretation'], isFalse);
    });

    test('toJson should include idempotency_key with snake_case key', () {
      const req = GenerateRequest(
        caseId: 'Case_001',
        findings: 'Findings.',
        idempotencyKey: 'test-uuid-generate-123',
      );

      final json = req.toJson();

      expect(json['idempotency_key'], 'test-uuid-generate-123');
    });
  });

  // ============================================================================
  // AppliedPreference
  // ============================================================================

  group('AppliedPreference deserialization', () {
    test('should deserialize from backend JSON', () {
      final json = {
        'preference_id': 'pref_abc',
        'preference_text': 'Use bullet points',
      };

      final pref = AppliedPreference.fromJson(json);

      expect(pref.preferenceId, 'pref_abc');
      expect(pref.preferenceText, 'Use bullet points');
    });

    test('should default to empty strings', () {
      final pref = AppliedPreference.fromJson(<String, dynamic>{});

      expect(pref.preferenceId, '');
      expect(pref.preferenceText, '');
    });
  });

  // ============================================================================
  // GenerationTrace Models
  // ============================================================================

  group('RetrievedPreferenceTrace deserialization', () {
    test('should deserialize all fields', () {
      final json = {
        'preference_id': 'pref_001',
        'preference_text': 'Be concise',
        'similarity_score': 0.87,
        'source_case_id': 'Case_003',
        'category': 'detail_level',
      };

      final trace = RetrievedPreferenceTrace.fromJson(json);

      expect(trace.preferenceId, 'pref_001');
      expect(trace.preferenceText, 'Be concise');
      expect(trace.similarityScore, closeTo(0.87, 0.001));
      expect(trace.sourceCaseId, 'Case_003');
      expect(trace.category, 'detail_level');
    });

    test('should handle missing optional fields', () {
      final json = {
        'preference_id': 'pref_002',
        'preference_text': 'Test',
        'similarity_score': 0.5,
      };

      final trace = RetrievedPreferenceTrace.fromJson(json);

      expect(trace.sourceCaseId, isNull);
      expect(trace.category, isNull);
    });
  });

  group('RetrievalTrace deserialization', () {
    test('should deserialize with retrieved preferences', () {
      final json = {
        'total_preferences': 15,
        'k_requested': 5,
        'k_returned': 3,
        'retrieved': [
          {
            'preference_id': 'p1',
            'preference_text': 'Pref 1',
            'similarity_score': 0.95,
          },
          {
            'preference_id': 'p2',
            'preference_text': 'Pref 2',
            'similarity_score': 0.80,
          },
        ],
      };

      final trace = RetrievalTrace.fromJson(json);

      expect(trace.totalPreferences, 15);
      expect(trace.kRequested, 5);
      expect(trace.kReturned, 3);
      expect(trace.retrieved, hasLength(2));
      expect(trace.retrieved[0].similarityScore, closeTo(0.95, 0.001));
    });

    test('should default to empty values', () {
      final trace = RetrievalTrace.fromJson(<String, dynamic>{});

      expect(trace.totalPreferences, 0);
      expect(trace.kRequested, 0);
      expect(trace.kReturned, 0);
      expect(trace.retrieved, isEmpty);
    });
  });

  group('RefinementTrace deserialization', () {
    test('should deserialize all fields', () {
      final json = {
        'was_applied': true,
        'base_length': 120,
        'refined_length': 95,
        'edit_distance': 0.18,
        'model_id': 'us.anthropic.claude-sonnet-4-5-v1',
      };

      final trace = RefinementTrace.fromJson(json);

      expect(trace.wasApplied, isTrue);
      expect(trace.baseLength, 120);
      expect(trace.refinedLength, 95);
      expect(trace.editDistance, closeTo(0.18, 0.001));
      expect(trace.modelId, 'us.anthropic.claude-sonnet-4-5-v1');
    });
  });

  group('GenerationTrace deserialization', () {
    test('should deserialize full trace from backend', () {
      final json = {
        'retrieval': {
          'total_preferences': 10,
          'k_requested': 5,
          'k_returned': 3,
          'retrieved': [],
        },
        'base_generation_model': 'us.anthropic.claude-sonnet-4-5-v1',
        'refinement': {
          'was_applied': true,
          'base_length': 100,
          'refined_length': 80,
          'edit_distance': 0.2,
        },
      };

      final trace = GenerationTrace.fromJson(json);

      expect(trace.retrieval, isNotNull);
      expect(trace.retrieval!.totalPreferences, 10);
      expect(trace.baseGenerationModel, 'us.anthropic.claude-sonnet-4-5-v1');
      expect(trace.refinement, isNotNull);
      expect(trace.refinement!.wasApplied, isTrue);
    });

    test('should handle null sub-traces', () {
      final trace = GenerationTrace.fromJson(<String, dynamic>{});

      expect(trace.retrieval, isNull);
      expect(trace.baseGenerationModel, isNull);
      expect(trace.refinement, isNull);
    });
  });

  // ============================================================================
  // GenerateResponse
  // ============================================================================

  group('GenerateResponse deserialization', () {
    test('should deserialize full generation response', () {
      final json = {
        'impression': '• No acute findings.',
        'base_impression': 'No acute findings detected.',
        'preferences_used': 3,
        'preferences_applied': [
          {'preference_id': 'p1', 'preference_text': 'Use bullets'},
          {'preference_id': 'p2', 'preference_text': 'Be concise'},
        ],
        'case_id': 'Case_001',
        'base_impression_model': 'us.anthropic.claude-sonnet-4-5-v1',
        'refinement_model': 'us.anthropic.claude-sonnet-4-5-v1',
        'trace': {
          'retrieval': {
            'total_preferences': 5,
            'k_requested': 3,
            'k_returned': 2,
            'retrieved': [],
          },
        },
      };

      final response = GenerateResponse.fromJson(json);

      expect(response.impression, '• No acute findings.');
      expect(response.baseImpression, 'No acute findings detected.');
      expect(response.preferencesUsed, 3);
      expect(response.preferencesApplied, hasLength(2));
      expect(response.caseId, 'Case_001');
      expect(response.baseImpressionModel, isNotNull);
      expect(response.refinementModel, isNotNull);
      expect(response.trace, isNotNull);
    });

    test('should default when minimal JSON', () {
      final response = GenerateResponse.fromJson(<String, dynamic>{});

      expect(response.impression, '');
      expect(response.baseImpression, '');
      expect(response.preferencesUsed, 0);
      expect(response.preferencesApplied, isEmpty);
      expect(response.caseId, '');
      expect(response.trace, isNull);
    });
  });

  // ============================================================================
  // Edit Models (Async Pattern)
  // ============================================================================

  group('EditRequest', () {
    test('toJson should produce snake_case keys', () {
      const req = EditRequest(
        caseId: 'Case_001',
        originalImpression: 'Original text.',
        editedImpression: 'Edited text.',
        findings: 'Findings.',
        idempotencyKey: 'test-uuid-edit',
      );

      final json = req.toJson();

      expect(json['case_id'], 'Case_001');
      expect(json['original_impression'], 'Original text.');
      expect(json['edited_impression'], 'Edited text.');
      expect(json['findings'], 'Findings.');
    });

    test('toJson should include idempotency_key with snake_case key', () {
      const req = EditRequest(
        caseId: 'Case_001',
        originalImpression: 'Original text.',
        editedImpression: 'Edited text.',
        findings: 'Findings.',
        idempotencyKey: 'test-uuid-edit-456',
      );

      final json = req.toJson();

      expect(json['idempotency_key'], 'test-uuid-edit-456');
    });
  });

  group('EditStartResponse deserialization', () {
    test('should deserialize from POST /edit response', () {
      final json = {
        'edit_id': 'edit_abc123',
        'status': 'processing',
        'poll_url': '/edit/edit_abc123/status',
      };

      final response = EditStartResponse.fromJson(json);

      expect(response.editId, 'edit_abc123');
      expect(response.status, 'processing');
      expect(response.pollUrl, '/edit/edit_abc123/status');
    });

    test('should default to pending status', () {
      final response = EditStartResponse.fromJson(<String, dynamic>{});

      expect(response.editId, '');
      expect(response.status, 'pending');
      expect(response.pollUrl, '');
    });
  });

  group('SavedPreferenceInfo deserialization', () {
    test('should deserialize all fields', () {
      final json = {
        'preference_id': 'pref_001',
        'preference_text': 'Use bullet points for list items',
        'category': 'formatting',
        'confidence': 0.92,
      };

      final info = SavedPreferenceInfo.fromJson(json);

      expect(info.preferenceId, 'pref_001');
      expect(info.preferenceText, 'Use bullet points for list items');
      expect(info.category, 'formatting');
      expect(info.confidence, closeTo(0.92, 0.001));
    });

    test('should handle null optional fields', () {
      final json = {
        'preference_id': 'pref_002',
        'preference_text': 'Be concise',
      };

      final info = SavedPreferenceInfo.fromJson(json);

      expect(info.category, isNull);
      expect(info.confidence, isNull);
    });
  });

  // ============================================================================
  // RejectedChangeInfo (Regression tests from bug fix)
  // ============================================================================

  group('RejectedChangeInfo deserialization', () {
    test('should deserialize rejection_reason from backend JSON', () {
      final json = {
        'change_description': 'Added differential diagnosis',
        'rejection_reason': 'Content-adding: clinical interpretation not allowed',
      };

      final info = RejectedChangeInfo.fromJson(json);

      expect(info.changeDescription, 'Added differential diagnosis');
      expect(
        info.reason,
        'Content-adding: clinical interpretation not allowed',
        reason: 'RejectedChangeInfo.reason must map to JSON key "rejection_reason"',
      );
    });

    test('should deserialize rejection_reason with risk_level', () {
      final json = {
        'change_description': 'Suggested follow-up imaging',
        'rejection_reason': 'Validator agent rejected: adds clinical recommendation',
        'risk_level': 'high',
      };

      final info = RejectedChangeInfo.fromJson(json);

      expect(info.changeDescription, 'Suggested follow-up imaging');
      expect(info.reason, contains('Validator agent rejected'));
      expect(info.riskLevel, 'high');
    });

    test('should default to empty string when rejection_reason is missing', () {
      final json = {
        'change_description': 'Some change',
      };

      final info = RejectedChangeInfo.fromJson(json);

      expect(info.changeDescription, 'Some change');
      expect(info.reason, '');
    });

    test('should NOT populate reason from a key named "reason"', () {
      // The backend sends "rejection_reason", not "reason".
      // If someone accidentally removes the @JsonKey annotation, the model
      // would look for "reason" instead. This test catches that regression.
      final jsonWithWrongKey = {
        'change_description': 'Some change',
        'reason': 'This should NOT be picked up if @JsonKey is correct',
        'rejection_reason': 'This is the correct value',
      };

      final info = RejectedChangeInfo.fromJson(jsonWithWrongKey);

      expect(info.reason, 'This is the correct value');
    });
  });

  // ============================================================================
  // EditStatusResponse
  // ============================================================================

  group('EditStatusResponse deserialization', () {
    test('should deserialize changes_rejected with rejection_reason', () {
      final json = {
        'edit_id': 'edit_123',
        'status': 'completed',
        'edit_distance': 0.25,
        'preference_inferred': true,
        'preferences_saved': [
          {
            'preference_id': 'pref_1',
            'preference_text': 'Use bullet points',
            'category': 'formatting',
            'confidence': 0.92,
          }
        ],
        'changes_rejected': [
          {
            'change_description': 'Summarized specific negatives',
            'rejection_reason': 'Classified as content-adding',
          },
          {
            'change_description': 'Added follow-up recommendation',
            'rejection_reason': 'Contains content-adding keyword: follow-up',
            'risk_level': 'medium',
          },
        ],
        'summary': 'Learned 1 preference. Rejected 2 changes.',
      };

      final response = EditStatusResponse.fromJson(json);

      expect(response.isComplete, isTrue);
      expect(response.isFailed, isFalse);
      expect(response.preferencesSaved, hasLength(1));
      expect(response.changesRejected, hasLength(2));
      expect(
        response.changesRejected![0].reason,
        'Classified as content-adding',
      );
      expect(
        response.changesRejected![1].reason,
        'Contains content-adding keyword: follow-up',
      );
      expect(response.changesRejected![1].riskLevel, 'medium');
    });

    test('should deserialize safety_warning when present', () {
      final json = {
        'edit_id': 'edit_456',
        'status': 'completed',
        'summary': 'Edit saved.',
        'safety_warning': 'Input contained suspicious patterns',
      };

      final response = EditStatusResponse.fromJson(json);

      expect(response.safetyWarning, 'Input contained suspicious patterns');
    });

    test('safety_warning should be null when not present', () {
      final json = {
        'edit_id': 'edit_789',
        'status': 'completed',
        'summary': 'Learned 1 preference.',
      };

      final response = EditStatusResponse.fromJson(json);

      expect(response.safetyWarning, isNull);
    });

    test('should handle failed status with error_message', () {
      final json = {
        'edit_id': 'edit_fail',
        'status': 'failed',
        'error_message': 'Agent timeout',
      };

      final response = EditStatusResponse.fromJson(json);

      expect(response.isComplete, isTrue);
      expect(response.isFailed, isTrue);
      expect(response.errorMessage, 'Agent timeout');
    });

    test('should handle processing status (not complete)', () {
      final json = {
        'edit_id': 'edit_proc',
        'status': 'processing',
      };

      final response = EditStatusResponse.fromJson(json);

      expect(response.isComplete, isFalse);
      expect(response.isFailed, isFalse);
    });

    test('should handle pending status (not complete)', () {
      final response = EditStatusResponse.fromJson(<String, dynamic>{});

      expect(response.status, 'pending');
      expect(response.isComplete, isFalse);
    });
  });

  group('RejectedChangeInfo serialization round-trip', () {
    test('toJson should produce rejection_reason key', () {
      const info = RejectedChangeInfo(
        changeDescription: 'Added diagnosis',
        reason: 'Content-adding clinical content',
        riskLevel: 'high',
      );

      final json = info.toJson();

      expect(json.containsKey('rejection_reason'), isTrue,
          reason: 'toJson must produce "rejection_reason" key');
      expect(json['rejection_reason'], 'Content-adding clinical content');
      expect(json['change_description'], 'Added diagnosis');
      expect(json['risk_level'], 'high');
    });
  });

  // ============================================================================
  // Case Update Models
  // ============================================================================

  group('UpdateCaseRequest', () {
    test('toJson should produce correct structure', () {
      const req = UpdateCaseRequest(findings: 'Updated findings text.');

      final json = req.toJson();

      expect(json['findings'], 'Updated findings text.');
    });
  });

  group('UpdateCaseResponse deserialization', () {
    test('should deserialize success response', () {
      final json = {
        'success': true,
        'message': 'Case updated',
        'case_id': 'Case_001',
      };

      final response = UpdateCaseResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Case updated');
      expect(response.caseId, 'Case_001');
    });

    test('should default success to true', () {
      final response = UpdateCaseResponse.fromJson(<String, dynamic>{});

      expect(response.success, isTrue);
      expect(response.message, isNull);
      expect(response.caseId, isNull);
    });
  });

  // ============================================================================
  // Preference Update/Delete Models
  // ============================================================================

  group('UpdatePreferenceRequest', () {
    test('toJson should produce preference_text key', () {
      const req = UpdatePreferenceRequest(preferenceText: 'Use concise language');

      final json = req.toJson();

      expect(json['preference_text'], 'Use concise language');
    });
  });

  group('UpdatePreferenceResponse deserialization', () {
    test('should deserialize with safety_warning', () {
      final json = {
        'success': true,
        'message': 'Preference updated',
        'safety_warning': 'Content was borderline',
      };

      final response = UpdatePreferenceResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.safetyWarning, 'Content was borderline');
    });

    test('should handle no safety_warning', () {
      final json = {
        'success': true,
        'message': 'OK',
      };

      final response = UpdatePreferenceResponse.fromJson(json);

      expect(response.safetyWarning, isNull);
    });
  });

  group('DeletePreferenceResponse deserialization', () {
    test('should deserialize success response', () {
      final json = {
        'success': true,
        'message': 'Preference deleted',
      };

      final response = DeletePreferenceResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Preference deleted');
    });
  });

  // ============================================================================
  // Error Models
  // ============================================================================

  group('ApiErrorDetail deserialization', () {
    test('should deserialize error detail', () {
      final json = {
        'code': 'VALIDATION_ERROR',
        'message': 'Invalid input: case_id is required',
      };

      final detail = ApiErrorDetail.fromJson(json);

      expect(detail.code, 'VALIDATION_ERROR');
      expect(detail.message, 'Invalid input: case_id is required');
    });

    test('should default to unknown error', () {
      final detail = ApiErrorDetail.fromJson(<String, dynamic>{});

      expect(detail.code, 'UNKNOWN_ERROR');
      expect(detail.message, 'An unknown error occurred');
    });
  });

  group('ApiErrorResponse deserialization', () {
    test('should deserialize error response from backend', () {
      final json = {
        'error': {
          'code': 'SAFETY_VIOLATION',
          'message': 'Edit rejected: contains clinical content',
        },
      };

      final response = ApiErrorResponse.fromJson(json);

      expect(response.error.code, 'SAFETY_VIOLATION');
      expect(response.error.message, contains('clinical content'));
    });
  });

  group('ApiErrorResponse.userMessage', () {
    test('VALIDATION_ERROR should pass through message', () {
      const response = ApiErrorResponse(
        error: ApiErrorDetail(
          code: 'VALIDATION_ERROR',
          message: 'case_id is required',
        ),
      );

      expect(response.userMessage, 'case_id is required');
    });

    test('SAFETY_VIOLATION should prefix with safety context', () {
      const response = ApiErrorResponse(
        error: ApiErrorDetail(
          code: 'SAFETY_VIOLATION',
          message: 'Contains clinical keyword: diagnosis',
        ),
      );

      expect(response.userMessage, contains('safety reasons'));
      expect(response.userMessage, contains('diagnosis'));
    });

    test('NOT_FOUND should show generic message', () {
      const response = ApiErrorResponse(
        error: ApiErrorDetail(
          code: 'NOT_FOUND',
          message: 'Preference pref_123 not found',
        ),
      );

      expect(response.userMessage, 'The requested resource was not found.');
    });

    test('UNAUTHORIZED should show sign in message', () {
      const response = ApiErrorResponse(
        error: ApiErrorDetail(
          code: 'UNAUTHORIZED',
          message: 'Token expired',
        ),
      );

      expect(response.userMessage, contains('sign in'));
    });

    test('unknown code should pass through message', () {
      const response = ApiErrorResponse(
        error: ApiErrorDetail(
          code: 'RATE_LIMITED',
          message: 'Too many requests',
        ),
      );

      expect(response.userMessage, 'Too many requests');
    });
  });
}
