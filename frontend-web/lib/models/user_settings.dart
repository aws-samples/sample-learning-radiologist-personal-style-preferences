import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

/// Data source for cases
enum DataSource {
  synthetic,
  mimic,
}

/// Model settings for each agent
@freezed
class ModelSettings with _$ModelSettings {
  const factory ModelSettings({
    @JsonKey(name: 'base_impression') @Default('sonnet') String baseImpression,
    @JsonKey(name: 'style_refinement') @Default('sonnet') String styleRefinement,
    @JsonKey(name: 'preference_inference')
    @Default('sonnet')
    String preferenceInference,
    @JsonKey(name: 'preference_validator')
    @Default('haiku')
    String preferenceValidator,
    @JsonKey(name: 'preference_edit_validator')
    @Default('haiku')
    String preferenceEditValidator,
  }) = _ModelSettings;

  factory ModelSettings.fromJson(Map<String, dynamic> json) =>
      _$ModelSettingsFromJson(json);
}

/// User settings response from GET /settings
@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    @JsonKey(name: 'clinical_interpretation')
    @Default(true)
    bool clinicalInterpretation,
    @JsonKey(name: 'model_settings')
    @Default(ModelSettings())
    ModelSettings modelSettings,
    @JsonKey(name: 'k_preferences') @Default(10) int kPreferences,
    @JsonKey(name: 'data_source') @Default('synthetic') String dataSource,
    @JsonKey(name: 'mimic_bucket') String? mimicBucket,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}

/// Request to update settings (PUT /settings)
@Freezed()
class UpdateSettingsRequest with _$UpdateSettingsRequest {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateSettingsRequest({
    @JsonKey(name: 'clinical_interpretation') bool? clinicalInterpretation,
    @JsonKey(name: 'model_settings') ModelSettings? modelSettings,
    @JsonKey(name: 'k_preferences') int? kPreferences,
    @JsonKey(name: 'data_source') String? dataSource,
    @JsonKey(name: 'mimic_bucket') String? mimicBucket,
  }) = _UpdateSettingsRequest;

  factory UpdateSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateSettingsRequestFromJson(json);
}

/// Response from PUT /settings
@freezed
class UpdateSettingsResponse with _$UpdateSettingsResponse {
  const factory UpdateSettingsResponse({
    @Default(true) bool success,
    String? message,
    @JsonKey(name: 'data_reset') bool? dataReset,
    @JsonKey(name: 'cases_loaded') int? casesLoaded,
  }) = _UpdateSettingsResponse;

  factory UpdateSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateSettingsResponseFromJson(json);
}

/// Available model options
class AvailableModels {
  AvailableModels._();

  static const Map<String, String> models = {
    'opus': 'Claude Opus 4.8',
    'sonnet': 'Claude Sonnet 4.6',
    'haiku': 'Claude Haiku 4.5',
  };

  /// Map from full API model names to short keys
  static const Map<String, String> _apiToShort = {
    'claude-opus-4.8': 'opus',
    'claude-opus-4.6': 'opus', // backward compat after model upgrade
    'claude-opus-4.5': 'opus', // backward compat after model upgrade
    'claude-sonnet-4.6': 'sonnet',
    'claude-sonnet-4.5': 'sonnet', // backward compat after model upgrade
    'claude-haiku-4.5': 'haiku',
  };

  static String displayName(String modelKey) {
    final normalized = normalizeModelKey(modelKey);
    return models[normalized] ?? modelKey;
  }

  /// Normalize model key from API format to short key
  static String normalizeModelKey(String key) {
    // If it's already a short key, return it
    if (models.containsKey(key)) {
      return key;
    }
    // Convert from API format
    return _apiToShort[key] ?? key;
  }
}
