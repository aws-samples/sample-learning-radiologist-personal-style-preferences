// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ModelSettingsImpl _$$ModelSettingsImplFromJson(Map<String, dynamic> json) =>
    _$ModelSettingsImpl(
      baseImpression: json['base_impression'] as String? ?? 'sonnet',
      styleRefinement: json['style_refinement'] as String? ?? 'sonnet',
      preferenceInference: json['preference_inference'] as String? ?? 'sonnet',
      preferenceValidator: json['preference_validator'] as String? ?? 'haiku',
      preferenceEditValidator:
          json['preference_edit_validator'] as String? ?? 'haiku',
    );

Map<String, dynamic> _$$ModelSettingsImplToJson(_$ModelSettingsImpl instance) =>
    <String, dynamic>{
      'base_impression': instance.baseImpression,
      'style_refinement': instance.styleRefinement,
      'preference_inference': instance.preferenceInference,
      'preference_validator': instance.preferenceValidator,
      'preference_edit_validator': instance.preferenceEditValidator,
    };

_$UserSettingsImpl _$$UserSettingsImplFromJson(Map<String, dynamic> json) =>
    _$UserSettingsImpl(
      clinicalInterpretation: json['clinical_interpretation'] as bool? ?? true,
      modelSettings: json['model_settings'] == null
          ? const ModelSettings()
          : ModelSettings.fromJson(
              json['model_settings'] as Map<String, dynamic>,
            ),
      kPreferences: (json['k_preferences'] as num?)?.toInt() ?? 10,
      dataSource: json['data_source'] as String? ?? 'synthetic',
      mimicBucket: json['mimic_bucket'] as String?,
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'clinical_interpretation': instance.clinicalInterpretation,
      'model_settings': instance.modelSettings,
      'k_preferences': instance.kPreferences,
      'data_source': instance.dataSource,
      'mimic_bucket': instance.mimicBucket,
    };

_$UpdateSettingsRequestImpl _$$UpdateSettingsRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateSettingsRequestImpl(
  clinicalInterpretation: json['clinical_interpretation'] as bool?,
  modelSettings: json['model_settings'] == null
      ? null
      : ModelSettings.fromJson(json['model_settings'] as Map<String, dynamic>),
  kPreferences: (json['k_preferences'] as num?)?.toInt(),
  dataSource: json['data_source'] as String?,
  mimicBucket: json['mimic_bucket'] as String?,
);

Map<String, dynamic> _$$UpdateSettingsRequestImplToJson(
  _$UpdateSettingsRequestImpl instance,
) => <String, dynamic>{
  if (instance.clinicalInterpretation case final value?)
    'clinical_interpretation': value,
  if (instance.modelSettings case final value?) 'model_settings': value,
  if (instance.kPreferences case final value?) 'k_preferences': value,
  if (instance.dataSource case final value?) 'data_source': value,
  if (instance.mimicBucket case final value?) 'mimic_bucket': value,
};

_$UpdateSettingsResponseImpl _$$UpdateSettingsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateSettingsResponseImpl(
  success: json['success'] as bool? ?? true,
  message: json['message'] as String?,
  dataReset: json['data_reset'] as bool?,
  casesLoaded: (json['cases_loaded'] as num?)?.toInt(),
);

Map<String, dynamic> _$$UpdateSettingsResponseImplToJson(
  _$UpdateSettingsResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data_reset': instance.dataReset,
  'cases_loaded': instance.casesLoaded,
};
