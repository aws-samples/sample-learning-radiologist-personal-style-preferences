import 'package:freezed_annotation/freezed_annotation.dart';

part 'preference.freezed.dart';
part 'preference.g.dart';

/// A learned style preference
@freezed
class Preference with _$Preference {
  const factory Preference({
    @JsonKey(name: 'preference_id') @Default('') String preferenceId,
    @JsonKey(name: 'preference_text') @Default('') String preferenceText,
    @JsonKey(name: 'source_case_id') @Default('') String sourceCaseId,
    @Default(0.0) double timestamp,
    String? category,
    double? confidence,
    @JsonKey(name: 'inference_explanation') String? inferenceExplanation,
    @JsonKey(name: 'original_inferred_text') String? originalInferredText,
    @JsonKey(name: 'last_edited_at') double? lastEditedAt,
    @JsonKey(name: 'user_edit_count') int? userEditCount,
    @JsonKey(name: 'source_edit_id') String? sourceEditId,
    @JsonKey(name: 'original_impression') String? originalImpression,
    @JsonKey(name: 'edited_impression') String? editedImpression,
    @JsonKey(name: 'context_findings') String? contextFindings,
    @JsonKey(name: 'edit_distance') double? editDistance,
    @JsonKey(name: 'inference_model') String? inferenceModel,
  }) = _Preference;

  factory Preference.fromJson(Map<String, dynamic> json) =>
      _$PreferenceFromJson(json);
}

/// Response from GET /preferences endpoint
@freezed
class PreferencesResponse with _$PreferencesResponse {
  const factory PreferencesResponse({
    @Default(0) int count,
    @Default([]) List<Preference> preferences,
  }) = _PreferencesResponse;

  factory PreferencesResponse.fromJson(Map<String, dynamic> json) =>
      _$PreferencesResponseFromJson(json);
}

/// A rejected preference change (audit trail)
@freezed
class RejectedPreference with _$RejectedPreference {
  const factory RejectedPreference({
    @JsonKey(name: 'rejection_id') @Default('') String rejectionId,
    @JsonKey(name: 'change_description') @Default('') String changeDescription,
    @JsonKey(name: 'rejection_reason') @Default('') String rejectionReason,
    @JsonKey(name: 'rejection_layer') @Default('') String rejectionLayer,
    @JsonKey(name: 'source_case_id') @Default('') String sourceCaseId,
    @Default(0.0) double timestamp,
    @JsonKey(name: 'risk_level') String? riskLevel,
    @JsonKey(name: 'inference_model') String? inferenceModel,
  }) = _RejectedPreference;

  factory RejectedPreference.fromJson(Map<String, dynamic> json) =>
      _$RejectedPreferenceFromJson(json);
}

/// Response from GET /preferences/rejected endpoint
@freezed
class RejectedPreferencesResponse with _$RejectedPreferencesResponse {
  const factory RejectedPreferencesResponse({
    @Default(0) int count,
    @JsonKey(name: 'rejected_preferences')
    @Default([]) List<RejectedPreference> rejectedPreferences,
  }) = _RejectedPreferencesResponse;

  factory RejectedPreferencesResponse.fromJson(Map<String, dynamic> json) =>
      _$RejectedPreferencesResponseFromJson(json);
}
