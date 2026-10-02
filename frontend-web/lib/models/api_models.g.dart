// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GenerateRequestImpl _$$GenerateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$GenerateRequestImpl(
      caseId: json['case_id'] as String,
      findings: json['findings'] as String,
      clinicalInterpretation: json['clinical_interpretation'] as bool? ?? false,
      idempotencyKey: json['idempotency_key'] as String,
    );

Map<String, dynamic> _$$GenerateRequestImplToJson(
        _$GenerateRequestImpl instance) =>
    <String, dynamic>{
      'case_id': instance.caseId,
      'findings': instance.findings,
      'clinical_interpretation': instance.clinicalInterpretation,
      'idempotency_key': instance.idempotencyKey,
    };

_$AppliedPreferenceImpl _$$AppliedPreferenceImplFromJson(
        Map<String, dynamic> json) =>
    _$AppliedPreferenceImpl(
      preferenceId: json['preference_id'] as String? ?? '',
      preferenceText: json['preference_text'] as String? ?? '',
    );

Map<String, dynamic> _$$AppliedPreferenceImplToJson(
        _$AppliedPreferenceImpl instance) =>
    <String, dynamic>{
      'preference_id': instance.preferenceId,
      'preference_text': instance.preferenceText,
    };

_$RetrievedPreferenceTraceImpl _$$RetrievedPreferenceTraceImplFromJson(
        Map<String, dynamic> json) =>
    _$RetrievedPreferenceTraceImpl(
      preferenceId: json['preference_id'] as String? ?? '',
      preferenceText: json['preference_text'] as String? ?? '',
      similarityScore: (json['similarity_score'] as num?)?.toDouble() ?? 0.0,
      sourceCaseId: json['source_case_id'] as String?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$$RetrievedPreferenceTraceImplToJson(
        _$RetrievedPreferenceTraceImpl instance) =>
    <String, dynamic>{
      'preference_id': instance.preferenceId,
      'preference_text': instance.preferenceText,
      'similarity_score': instance.similarityScore,
      'source_case_id': instance.sourceCaseId,
      'category': instance.category,
    };

_$RetrievalTraceImpl _$$RetrievalTraceImplFromJson(Map<String, dynamic> json) =>
    _$RetrievalTraceImpl(
      totalPreferences: (json['total_preferences'] as num?)?.toInt() ?? 0,
      kRequested: (json['k_requested'] as num?)?.toInt() ?? 0,
      kReturned: (json['k_returned'] as num?)?.toInt() ?? 0,
      retrieved: (json['retrieved'] as List<dynamic>?)
              ?.map((e) =>
                  RetrievedPreferenceTrace.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RetrievalTraceImplToJson(
        _$RetrievalTraceImpl instance) =>
    <String, dynamic>{
      'total_preferences': instance.totalPreferences,
      'k_requested': instance.kRequested,
      'k_returned': instance.kReturned,
      'retrieved': instance.retrieved,
    };

_$RefinementTraceImpl _$$RefinementTraceImplFromJson(
        Map<String, dynamic> json) =>
    _$RefinementTraceImpl(
      wasApplied: json['was_applied'] as bool? ?? false,
      baseLength: (json['base_length'] as num?)?.toInt() ?? 0,
      refinedLength: (json['refined_length'] as num?)?.toInt() ?? 0,
      editDistance: (json['edit_distance'] as num?)?.toDouble() ?? 0.0,
      modelId: json['model_id'] as String?,
    );

Map<String, dynamic> _$$RefinementTraceImplToJson(
        _$RefinementTraceImpl instance) =>
    <String, dynamic>{
      'was_applied': instance.wasApplied,
      'base_length': instance.baseLength,
      'refined_length': instance.refinedLength,
      'edit_distance': instance.editDistance,
      'model_id': instance.modelId,
    };

_$GenerationTraceImpl _$$GenerationTraceImplFromJson(
        Map<String, dynamic> json) =>
    _$GenerationTraceImpl(
      retrieval: json['retrieval'] == null
          ? null
          : RetrievalTrace.fromJson(json['retrieval'] as Map<String, dynamic>),
      baseGenerationModel: json['base_generation_model'] as String?,
      refinement: json['refinement'] == null
          ? null
          : RefinementTrace.fromJson(
              json['refinement'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GenerationTraceImplToJson(
        _$GenerationTraceImpl instance) =>
    <String, dynamic>{
      'retrieval': instance.retrieval,
      'base_generation_model': instance.baseGenerationModel,
      'refinement': instance.refinement,
    };

_$GenerateResponseImpl _$$GenerateResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GenerateResponseImpl(
      impression: json['impression'] as String? ?? '',
      baseImpression: json['base_impression'] as String? ?? '',
      preferencesUsed: (json['preferences_used'] as num?)?.toInt() ?? 0,
      preferencesApplied: (json['preferences_applied'] as List<dynamic>?)
              ?.map(
                  (e) => AppliedPreference.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      caseId: json['case_id'] as String? ?? '',
      baseImpressionModel: json['base_impression_model'] as String?,
      refinementModel: json['refinement_model'] as String?,
      trace: json['trace'] == null
          ? null
          : GenerationTrace.fromJson(json['trace'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GenerateResponseImplToJson(
        _$GenerateResponseImpl instance) =>
    <String, dynamic>{
      'impression': instance.impression,
      'base_impression': instance.baseImpression,
      'preferences_used': instance.preferencesUsed,
      'preferences_applied': instance.preferencesApplied,
      'case_id': instance.caseId,
      'base_impression_model': instance.baseImpressionModel,
      'refinement_model': instance.refinementModel,
      'trace': instance.trace,
    };

_$EditRequestImpl _$$EditRequestImplFromJson(Map<String, dynamic> json) =>
    _$EditRequestImpl(
      caseId: json['case_id'] as String,
      originalImpression: json['original_impression'] as String,
      editedImpression: json['edited_impression'] as String,
      findings: json['findings'] as String,
      idempotencyKey: json['idempotency_key'] as String,
    );

Map<String, dynamic> _$$EditRequestImplToJson(_$EditRequestImpl instance) =>
    <String, dynamic>{
      'case_id': instance.caseId,
      'original_impression': instance.originalImpression,
      'edited_impression': instance.editedImpression,
      'findings': instance.findings,
      'idempotency_key': instance.idempotencyKey,
    };

_$EditStartResponseImpl _$$EditStartResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$EditStartResponseImpl(
      editId: json['edit_id'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      pollUrl: json['poll_url'] as String? ?? '',
    );

Map<String, dynamic> _$$EditStartResponseImplToJson(
        _$EditStartResponseImpl instance) =>
    <String, dynamic>{
      'edit_id': instance.editId,
      'status': instance.status,
      'poll_url': instance.pollUrl,
    };

_$SavedPreferenceInfoImpl _$$SavedPreferenceInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$SavedPreferenceInfoImpl(
      preferenceId: json['preference_id'] as String? ?? '',
      preferenceText: json['preference_text'] as String? ?? '',
      category: json['category'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$SavedPreferenceInfoImplToJson(
        _$SavedPreferenceInfoImpl instance) =>
    <String, dynamic>{
      'preference_id': instance.preferenceId,
      'preference_text': instance.preferenceText,
      'category': instance.category,
      'confidence': instance.confidence,
    };

_$RejectedChangeInfoImpl _$$RejectedChangeInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$RejectedChangeInfoImpl(
      changeDescription: json['change_description'] as String? ?? '',
      reason: json['rejection_reason'] as String? ?? '',
      riskLevel: json['risk_level'] as String?,
    );

Map<String, dynamic> _$$RejectedChangeInfoImplToJson(
        _$RejectedChangeInfoImpl instance) =>
    <String, dynamic>{
      'change_description': instance.changeDescription,
      'rejection_reason': instance.reason,
      'risk_level': instance.riskLevel,
    };

_$EditStatusResponseImpl _$$EditStatusResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$EditStatusResponseImpl(
      editId: json['edit_id'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      editDistance: (json['edit_distance'] as num?)?.toDouble(),
      preferenceInferred: json['preference_inferred'] as bool?,
      preferencesSaved: (json['preferences_saved'] as List<dynamic>?)
          ?.map((e) => SavedPreferenceInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      changesRejected: (json['changes_rejected'] as List<dynamic>?)
          ?.map((e) => RejectedChangeInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: json['summary'] as String?,
      safetyWarning: json['safety_warning'] as String?,
      errorMessage: json['error_message'] as String?,
    );

Map<String, dynamic> _$$EditStatusResponseImplToJson(
        _$EditStatusResponseImpl instance) =>
    <String, dynamic>{
      'edit_id': instance.editId,
      'status': instance.status,
      'edit_distance': instance.editDistance,
      'preference_inferred': instance.preferenceInferred,
      'preferences_saved': instance.preferencesSaved,
      'changes_rejected': instance.changesRejected,
      'summary': instance.summary,
      'safety_warning': instance.safetyWarning,
      'error_message': instance.errorMessage,
    };

_$UpdateCaseRequestImpl _$$UpdateCaseRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateCaseRequestImpl(
      findings: json['findings'] as String,
    );

Map<String, dynamic> _$$UpdateCaseRequestImplToJson(
        _$UpdateCaseRequestImpl instance) =>
    <String, dynamic>{
      'findings': instance.findings,
    };

_$UpdateCaseResponseImpl _$$UpdateCaseResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateCaseResponseImpl(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
      caseId: json['case_id'] as String?,
    );

Map<String, dynamic> _$$UpdateCaseResponseImplToJson(
        _$UpdateCaseResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'case_id': instance.caseId,
    };

_$UpdatePreferenceRequestImpl _$$UpdatePreferenceRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdatePreferenceRequestImpl(
      preferenceText: json['preference_text'] as String,
    );

Map<String, dynamic> _$$UpdatePreferenceRequestImplToJson(
        _$UpdatePreferenceRequestImpl instance) =>
    <String, dynamic>{
      'preference_text': instance.preferenceText,
    };

_$UpdatePreferenceResponseImpl _$$UpdatePreferenceResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdatePreferenceResponseImpl(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
      safetyWarning: json['safety_warning'] as String?,
    );

Map<String, dynamic> _$$UpdatePreferenceResponseImplToJson(
        _$UpdatePreferenceResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'safety_warning': instance.safetyWarning,
    };

_$DeletePreferenceResponseImpl _$$DeletePreferenceResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$DeletePreferenceResponseImpl(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$DeletePreferenceResponseImplToJson(
        _$DeletePreferenceResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
    };

_$ApiErrorDetailImpl _$$ApiErrorDetailImplFromJson(Map<String, dynamic> json) =>
    _$ApiErrorDetailImpl(
      code: json['code'] as String? ?? 'UNKNOWN_ERROR',
      message: json['message'] as String? ?? 'An unknown error occurred',
    );

Map<String, dynamic> _$$ApiErrorDetailImplToJson(
        _$ApiErrorDetailImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };

_$ApiErrorResponseImpl _$$ApiErrorResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiErrorResponseImpl(
      error: ApiErrorDetail.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ApiErrorResponseImplToJson(
        _$ApiErrorResponseImpl instance) =>
    <String, dynamic>{
      'error': instance.error,
    };
