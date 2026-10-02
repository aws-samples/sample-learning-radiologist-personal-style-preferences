// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'case.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CaseImpl _$$CaseImplFromJson(Map<String, dynamic> json) => _$CaseImpl(
      caseId: json['case_id'] as String? ?? '',
      findings: json['findings'] as String? ?? '',
      hasGenerated: json['has_generated'] as bool? ?? false,
      hasEdited: json['has_edited'] as bool? ?? false,
    );

Map<String, dynamic> _$$CaseImplToJson(_$CaseImpl instance) =>
    <String, dynamic>{
      'case_id': instance.caseId,
      'findings': instance.findings,
      'has_generated': instance.hasGenerated,
      'has_edited': instance.hasEdited,
    };

_$CasesResponseImpl _$$CasesResponseImplFromJson(Map<String, dynamic> json) =>
    _$CasesResponseImpl(
      count: (json['count'] as num?)?.toInt() ?? 0,
      cases: (json['cases'] as List<dynamic>?)
              ?.map((e) => Case.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CasesResponseImplToJson(_$CasesResponseImpl instance) =>
    <String, dynamic>{
      'count': instance.count,
      'cases': instance.cases,
    };

_$CaseAppliedPreferenceImpl _$$CaseAppliedPreferenceImplFromJson(
        Map<String, dynamic> json) =>
    _$CaseAppliedPreferenceImpl(
      preferenceId: json['preference_id'] as String? ?? '',
      preferenceText: json['preference_text'] as String? ?? '',
    );

Map<String, dynamic> _$$CaseAppliedPreferenceImplToJson(
        _$CaseAppliedPreferenceImpl instance) =>
    <String, dynamic>{
      'preference_id': instance.preferenceId,
      'preference_text': instance.preferenceText,
    };

_$CaseImageUrlImpl _$$CaseImageUrlImplFromJson(Map<String, dynamic> json) =>
    _$CaseImageUrlImpl(
      view: json['view'] as String? ?? '',
      url: json['url'] as String? ?? '',
      expiresAt: (json['expires_at'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CaseImageUrlImplToJson(_$CaseImageUrlImpl instance) =>
    <String, dynamic>{
      'view': instance.view,
      'url': instance.url,
      'expires_at': instance.expiresAt,
    };

_$CaseEditHistoryEntryImpl _$$CaseEditHistoryEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$CaseEditHistoryEntryImpl(
      editId: json['edit_id'] as String? ?? '',
      originalImpression: json['original_impression'] as String? ?? '',
      editedImpression: json['edited_impression'] as String? ?? '',
      editDistance: (json['edit_distance'] as num?)?.toDouble() ?? 0.0,
      timestamp: (json['timestamp'] as num?)?.toDouble() ?? 0.0,
      source: json['source'] as String? ?? 'unknown',
      preferencesSnapshot: (json['preferences_snapshot'] as List<dynamic>?)
          ?.map(
              (e) => CaseAppliedPreference.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CaseEditHistoryEntryImplToJson(
        _$CaseEditHistoryEntryImpl instance) =>
    <String, dynamic>{
      'edit_id': instance.editId,
      'original_impression': instance.originalImpression,
      'edited_impression': instance.editedImpression,
      'edit_distance': instance.editDistance,
      'timestamp': instance.timestamp,
      'source': instance.source,
      'preferences_snapshot': instance.preferencesSnapshot,
    };

_$CaseDetailImpl _$$CaseDetailImplFromJson(Map<String, dynamic> json) =>
    _$CaseDetailImpl(
      caseId: json['case_id'] as String? ?? '',
      findings: json['findings'] as String? ?? '',
      referenceImpression: json['reference_impression'] as String?,
      generatedImpression: json['generated_impression'] as String?,
      editedImpression: json['edited_impression'] as String?,
      generatedAt: (json['generated_at'] as num?)?.toDouble(),
      editedAt: (json['edited_at'] as num?)?.toDouble(),
      baseImpression: json['base_impression'] as String?,
      preferencesApplied: (json['preferences_applied'] as List<dynamic>?)
          ?.map(
              (e) => CaseAppliedPreference.fromJson(e as Map<String, dynamic>))
          .toList(),
      baseImpressionModel: json['base_impression_model'] as String?,
      refinementModel: json['refinement_model'] as String?,
      editHistory: (json['edit_history'] as List<dynamic>?)
          ?.map((e) => CaseEditHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageUrls: (json['image_urls'] as List<dynamic>?)
          ?.map((e) => CaseImageUrl.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CaseDetailImplToJson(_$CaseDetailImpl instance) =>
    <String, dynamic>{
      'case_id': instance.caseId,
      'findings': instance.findings,
      'reference_impression': instance.referenceImpression,
      'generated_impression': instance.generatedImpression,
      'edited_impression': instance.editedImpression,
      'generated_at': instance.generatedAt,
      'edited_at': instance.editedAt,
      'base_impression': instance.baseImpression,
      'preferences_applied': instance.preferencesApplied,
      'base_impression_model': instance.baseImpressionModel,
      'refinement_model': instance.refinementModel,
      'edit_history': instance.editHistory,
      'image_urls': instance.imageUrls,
    };
