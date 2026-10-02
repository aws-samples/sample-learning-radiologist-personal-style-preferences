// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PreferenceImpl _$$PreferenceImplFromJson(Map<String, dynamic> json) =>
    _$PreferenceImpl(
      preferenceId: json['preference_id'] as String? ?? '',
      preferenceText: json['preference_text'] as String? ?? '',
      sourceCaseId: json['source_case_id'] as String? ?? '',
      timestamp: (json['timestamp'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      inferenceExplanation: json['inference_explanation'] as String?,
      originalInferredText: json['original_inferred_text'] as String?,
      lastEditedAt: (json['last_edited_at'] as num?)?.toDouble(),
      userEditCount: (json['user_edit_count'] as num?)?.toInt(),
      sourceEditId: json['source_edit_id'] as String?,
      originalImpression: json['original_impression'] as String?,
      editedImpression: json['edited_impression'] as String?,
      contextFindings: json['context_findings'] as String?,
      editDistance: (json['edit_distance'] as num?)?.toDouble(),
      inferenceModel: json['inference_model'] as String?,
    );

Map<String, dynamic> _$$PreferenceImplToJson(_$PreferenceImpl instance) =>
    <String, dynamic>{
      'preference_id': instance.preferenceId,
      'preference_text': instance.preferenceText,
      'source_case_id': instance.sourceCaseId,
      'timestamp': instance.timestamp,
      'category': instance.category,
      'confidence': instance.confidence,
      'inference_explanation': instance.inferenceExplanation,
      'original_inferred_text': instance.originalInferredText,
      'last_edited_at': instance.lastEditedAt,
      'user_edit_count': instance.userEditCount,
      'source_edit_id': instance.sourceEditId,
      'original_impression': instance.originalImpression,
      'edited_impression': instance.editedImpression,
      'context_findings': instance.contextFindings,
      'edit_distance': instance.editDistance,
      'inference_model': instance.inferenceModel,
    };

_$PreferencesResponseImpl _$$PreferencesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PreferencesResponseImpl(
      count: (json['count'] as num?)?.toInt() ?? 0,
      preferences: (json['preferences'] as List<dynamic>?)
              ?.map((e) => Preference.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PreferencesResponseImplToJson(
        _$PreferencesResponseImpl instance) =>
    <String, dynamic>{
      'count': instance.count,
      'preferences': instance.preferences,
    };

_$RejectedPreferenceImpl _$$RejectedPreferenceImplFromJson(
        Map<String, dynamic> json) =>
    _$RejectedPreferenceImpl(
      rejectionId: json['rejection_id'] as String? ?? '',
      changeDescription: json['change_description'] as String? ?? '',
      rejectionReason: json['rejection_reason'] as String? ?? '',
      rejectionLayer: json['rejection_layer'] as String? ?? '',
      sourceCaseId: json['source_case_id'] as String? ?? '',
      timestamp: (json['timestamp'] as num?)?.toDouble() ?? 0.0,
      riskLevel: json['risk_level'] as String?,
      inferenceModel: json['inference_model'] as String?,
    );

Map<String, dynamic> _$$RejectedPreferenceImplToJson(
        _$RejectedPreferenceImpl instance) =>
    <String, dynamic>{
      'rejection_id': instance.rejectionId,
      'change_description': instance.changeDescription,
      'rejection_reason': instance.rejectionReason,
      'rejection_layer': instance.rejectionLayer,
      'source_case_id': instance.sourceCaseId,
      'timestamp': instance.timestamp,
      'risk_level': instance.riskLevel,
      'inference_model': instance.inferenceModel,
    };

_$RejectedPreferencesResponseImpl _$$RejectedPreferencesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RejectedPreferencesResponseImpl(
      count: (json['count'] as num?)?.toInt() ?? 0,
      rejectedPreferences: (json['rejected_preferences'] as List<dynamic>?)
              ?.map(
                  (e) => RejectedPreference.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RejectedPreferencesResponseImplToJson(
        _$RejectedPreferencesResponseImpl instance) =>
    <String, dynamic>{
      'count': instance.count,
      'rejected_preferences': instance.rejectedPreferences,
    };
