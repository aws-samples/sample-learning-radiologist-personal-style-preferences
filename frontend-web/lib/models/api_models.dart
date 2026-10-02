import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_models.freezed.dart';
part 'api_models.g.dart';

// ============================================================================
// Generation Models
// ============================================================================

/// Request to generate an impression (POST /generate)
@freezed
class GenerateRequest with _$GenerateRequest {
  const factory GenerateRequest({
    @JsonKey(name: 'case_id') required String caseId,
    required String findings,
    @JsonKey(name: 'clinical_interpretation')
    @Default(false)
    bool clinicalInterpretation,
    @JsonKey(name: 'idempotency_key') required String idempotencyKey,
  }) = _GenerateRequest;

  factory GenerateRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateRequestFromJson(json);
}

/// Applied preference in generation response
@freezed
class AppliedPreference with _$AppliedPreference {
  const factory AppliedPreference({
    @JsonKey(name: 'preference_id') @Default('') String preferenceId,
    @JsonKey(name: 'preference_text') @Default('') String preferenceText,
  }) = _AppliedPreference;

  factory AppliedPreference.fromJson(Map<String, dynamic> json) =>
      _$AppliedPreferenceFromJson(json);
}

// ============================================================================
// Generation Trace Models (X4 — AI Reasoning panel)
// ============================================================================

/// A preference retrieved by k-NN with its similarity score
@freezed
class RetrievedPreferenceTrace with _$RetrievedPreferenceTrace {
  const factory RetrievedPreferenceTrace({
    @JsonKey(name: 'preference_id') @Default('') String preferenceId,
    @JsonKey(name: 'preference_text') @Default('') String preferenceText,
    @JsonKey(name: 'similarity_score') @Default(0.0) double similarityScore,
    @JsonKey(name: 'source_case_id') String? sourceCaseId,
    String? category,
  }) = _RetrievedPreferenceTrace;
  factory RetrievedPreferenceTrace.fromJson(Map<String, dynamic> json) =>
      _$RetrievedPreferenceTraceFromJson(json);
}

/// Trace of the k-NN preference retrieval step
@freezed
class RetrievalTrace with _$RetrievalTrace {
  const factory RetrievalTrace({
    @JsonKey(name: 'total_preferences') @Default(0) int totalPreferences,
    @JsonKey(name: 'k_requested') @Default(0) int kRequested,
    @JsonKey(name: 'k_returned') @Default(0) int kReturned,
    @Default([]) List<RetrievedPreferenceTrace> retrieved,
  }) = _RetrievalTrace;
  factory RetrievalTrace.fromJson(Map<String, dynamic> json) =>
      _$RetrievalTraceFromJson(json);
}

/// Trace of the style refinement step
@freezed
class RefinementTrace with _$RefinementTrace {
  const factory RefinementTrace({
    @JsonKey(name: 'was_applied') @Default(false) bool wasApplied,
    @JsonKey(name: 'base_length') @Default(0) int baseLength,
    @JsonKey(name: 'refined_length') @Default(0) int refinedLength,
    @JsonKey(name: 'edit_distance') @Default(0.0) double editDistance,
    @JsonKey(name: 'model_id') String? modelId,
  }) = _RefinementTrace;
  factory RefinementTrace.fromJson(Map<String, dynamic> json) =>
      _$RefinementTraceFromJson(json);
}

/// Full trace of the generation pipeline
@freezed
class GenerationTrace with _$GenerationTrace {
  const factory GenerationTrace({
    RetrievalTrace? retrieval,
    @JsonKey(name: 'base_generation_model') String? baseGenerationModel,
    RefinementTrace? refinement,
  }) = _GenerationTrace;
  factory GenerationTrace.fromJson(Map<String, dynamic> json) =>
      _$GenerationTraceFromJson(json);
}

/// Response from POST /generate
@freezed
class GenerateResponse with _$GenerateResponse {
  const factory GenerateResponse({
    @Default('') String impression,
    @JsonKey(name: 'base_impression') @Default('') String baseImpression,
    @JsonKey(name: 'preferences_used') @Default(0) int preferencesUsed,
    @JsonKey(name: 'preferences_applied')
    @Default([])
    List<AppliedPreference> preferencesApplied,
    @JsonKey(name: 'case_id') @Default('') String caseId,
    @JsonKey(name: 'base_impression_model') String? baseImpressionModel,
    @JsonKey(name: 'refinement_model') String? refinementModel,
    GenerationTrace? trace,
  }) = _GenerateResponse;

  factory GenerateResponse.fromJson(Map<String, dynamic> json) =>
      _$GenerateResponseFromJson(json);
}

// ============================================================================
// Edit Models (Async Pattern)
// ============================================================================

/// Request to start an edit operation (POST /edit)
@freezed
class EditRequest with _$EditRequest {
  const factory EditRequest({
    @JsonKey(name: 'case_id') required String caseId,
    @JsonKey(name: 'original_impression') required String originalImpression,
    @JsonKey(name: 'edited_impression') required String editedImpression,
    required String findings,
    @JsonKey(name: 'idempotency_key') required String idempotencyKey,
  }) = _EditRequest;

  factory EditRequest.fromJson(Map<String, dynamic> json) =>
      _$EditRequestFromJson(json);
}

/// Response from POST /edit (immediate)
@freezed
class EditStartResponse with _$EditStartResponse {
  const factory EditStartResponse({
    @JsonKey(name: 'edit_id') @Default('') String editId,
    @Default('pending') String status,
    @JsonKey(name: 'poll_url') @Default('') String pollUrl,
  }) = _EditStartResponse;

  factory EditStartResponse.fromJson(Map<String, dynamic> json) =>
      _$EditStartResponseFromJson(json);
}

/// Saved preference info in edit status
@freezed
class SavedPreferenceInfo with _$SavedPreferenceInfo {
  const factory SavedPreferenceInfo({
    @JsonKey(name: 'preference_id') @Default('') String preferenceId,
    @JsonKey(name: 'preference_text') @Default('') String preferenceText,
    String? category,
    double? confidence,
  }) = _SavedPreferenceInfo;

  factory SavedPreferenceInfo.fromJson(Map<String, dynamic> json) =>
      _$SavedPreferenceInfoFromJson(json);
}

/// Rejected change info in edit status
@freezed
class RejectedChangeInfo with _$RejectedChangeInfo {
  const factory RejectedChangeInfo({
    @JsonKey(name: 'change_description') @Default('') String changeDescription,
    @JsonKey(name: 'rejection_reason') @Default('') String reason,
    @JsonKey(name: 'risk_level') String? riskLevel,
  }) = _RejectedChangeInfo;

  factory RejectedChangeInfo.fromJson(Map<String, dynamic> json) =>
      _$RejectedChangeInfoFromJson(json);
}

/// Response from GET /edit/{editId}/status (polling)
@freezed
class EditStatusResponse with _$EditStatusResponse {
  const EditStatusResponse._();

  const factory EditStatusResponse({
    @JsonKey(name: 'edit_id') @Default('') String editId,
    @Default('pending') String status,
    @JsonKey(name: 'edit_distance') double? editDistance,
    @JsonKey(name: 'preference_inferred') bool? preferenceInferred,
    @JsonKey(name: 'preferences_saved') List<SavedPreferenceInfo>? preferencesSaved,
    @JsonKey(name: 'changes_rejected') List<RejectedChangeInfo>? changesRejected,
    String? summary,
    @JsonKey(name: 'safety_warning') String? safetyWarning,
    @JsonKey(name: 'error_message') String? errorMessage,
  }) = _EditStatusResponse;

  factory EditStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$EditStatusResponseFromJson(json);

  /// Whether the edit operation is complete (success or failure)
  bool get isComplete => status == 'completed' || status == 'failed';

  /// Whether the edit operation failed
  bool get isFailed => status == 'failed';
}

// ============================================================================
// Case Update Models
// ============================================================================

/// Request to update case findings (PUT /cases/{caseId})
@freezed
class UpdateCaseRequest with _$UpdateCaseRequest {
  const factory UpdateCaseRequest({
    required String findings,
  }) = _UpdateCaseRequest;

  factory UpdateCaseRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCaseRequestFromJson(json);
}

/// Response from PUT /cases/{caseId}
@freezed
class UpdateCaseResponse with _$UpdateCaseResponse {
  const factory UpdateCaseResponse({
    @Default(true) bool success,
    String? message,
    @JsonKey(name: 'case_id') String? caseId,
  }) = _UpdateCaseResponse;

  factory UpdateCaseResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateCaseResponseFromJson(json);
}

// ============================================================================
// Preference Update/Delete Models
// ============================================================================

/// Request to update preference (PUT /preferences/{preferenceId})
@freezed
class UpdatePreferenceRequest with _$UpdatePreferenceRequest {
  const factory UpdatePreferenceRequest({
    @JsonKey(name: 'preference_text') required String preferenceText,
  }) = _UpdatePreferenceRequest;

  factory UpdatePreferenceRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePreferenceRequestFromJson(json);
}

/// Response from PUT /preferences/{preferenceId}
@freezed
class UpdatePreferenceResponse with _$UpdatePreferenceResponse {
  const factory UpdatePreferenceResponse({
    @Default(true) bool success,
    String? message,
    @JsonKey(name: 'safety_warning') String? safetyWarning,
  }) = _UpdatePreferenceResponse;

  factory UpdatePreferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdatePreferenceResponseFromJson(json);
}

/// Response from DELETE /preferences/{preferenceId}
@freezed
class DeletePreferenceResponse with _$DeletePreferenceResponse {
  const factory DeletePreferenceResponse({
    @Default(true) bool success,
    String? message,
  }) = _DeletePreferenceResponse;

  factory DeletePreferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$DeletePreferenceResponseFromJson(json);
}

// ============================================================================
// Error Models
// ============================================================================

/// API error detail
@freezed
class ApiErrorDetail with _$ApiErrorDetail {
  const factory ApiErrorDetail({
    @Default('UNKNOWN_ERROR') String code,
    @Default('An unknown error occurred') String message,
  }) = _ApiErrorDetail;

  factory ApiErrorDetail.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorDetailFromJson(json);
}

/// API error response structure
@freezed
class ApiErrorResponse with _$ApiErrorResponse {
  const ApiErrorResponse._();

  const factory ApiErrorResponse({
    required ApiErrorDetail error,
  }) = _ApiErrorResponse;

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);

  /// Maps error codes to user-friendly messages
  String get userMessage {
    switch (error.code) {
      case 'VALIDATION_ERROR':
        return error.message;
      case 'SAFETY_VIOLATION':
        return 'This edit was rejected for safety reasons: ${error.message}';
      case 'NOT_FOUND':
        return 'The requested resource was not found.';
      case 'UNAUTHORIZED':
        return 'Please sign in to continue.';
      default:
        return error.message;
    }
  }
}
