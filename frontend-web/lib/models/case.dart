import 'package:freezed_annotation/freezed_annotation.dart';

part 'case.freezed.dart';
part 'case.g.dart';

/// Represents a radiology case in the list view
@freezed
class Case with _$Case {
  const factory Case({
    @JsonKey(name: 'case_id') @Default('') String caseId,
    @Default('') String findings,
    @JsonKey(name: 'has_generated') @Default(false) bool hasGenerated,
    @JsonKey(name: 'has_edited') @Default(false) bool hasEdited,
  }) = _Case;

  factory Case.fromJson(Map<String, dynamic> json) => _$CaseFromJson(json);
}

/// Response from GET /cases endpoint
@freezed
class CasesResponse with _$CasesResponse {
  const factory CasesResponse({
    @Default(0) int count,
    @Default([]) List<Case> cases,
  }) = _CasesResponse;

  factory CasesResponse.fromJson(Map<String, dynamic> json) =>
      _$CasesResponseFromJson(json);
}

/// Applied preference reference in case detail
@freezed
class CaseAppliedPreference with _$CaseAppliedPreference {
  const factory CaseAppliedPreference({
    @JsonKey(name: 'preference_id') @Default('') String preferenceId,
    @JsonKey(name: 'preference_text') @Default('') String preferenceText,
  }) = _CaseAppliedPreference;

  factory CaseAppliedPreference.fromJson(Map<String, dynamic> json) =>
      _$CaseAppliedPreferenceFromJson(json);
}

/// Image URL for case X-ray images
@freezed
class CaseImageUrl with _$CaseImageUrl {
  const factory CaseImageUrl({
    @Default('') String view,
    @Default('') String url,
    @JsonKey(name: 'expires_at') double? expiresAt,
  }) = _CaseImageUrl;

  factory CaseImageUrl.fromJson(Map<String, dynamic> json) =>
      _$CaseImageUrlFromJson(json);
}

/// Entry in the case edit history
@freezed
class CaseEditHistoryEntry with _$CaseEditHistoryEntry {
  const factory CaseEditHistoryEntry({
    @JsonKey(name: 'edit_id') @Default('') String editId,
    @JsonKey(name: 'original_impression') @Default('') String originalImpression,
    @JsonKey(name: 'edited_impression') @Default('') String editedImpression,
    @JsonKey(name: 'edit_distance') @Default(0.0) double editDistance,
    @Default(0.0) double timestamp,
    @Default('unknown') String source,
    @JsonKey(name: 'preferences_snapshot')
    List<CaseAppliedPreference>? preferencesSnapshot,
  }) = _CaseEditHistoryEntry;

  factory CaseEditHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$CaseEditHistoryEntryFromJson(json);
}

/// Detailed case information from GET /cases/{caseId}
@freezed
class CaseDetail with _$CaseDetail {
  const CaseDetail._();

  const factory CaseDetail({
    @JsonKey(name: 'case_id') @Default('') String caseId,
    @Default('') String findings,
    @JsonKey(name: 'reference_impression') String? referenceImpression,
    @JsonKey(name: 'generated_impression') String? generatedImpression,
    @JsonKey(name: 'edited_impression') String? editedImpression,
    @JsonKey(name: 'generated_at') double? generatedAt,
    @JsonKey(name: 'edited_at') double? editedAt,
    @JsonKey(name: 'base_impression') String? baseImpression,
    @JsonKey(name: 'preferences_applied')
    List<CaseAppliedPreference>? preferencesApplied,
    @JsonKey(name: 'base_impression_model') String? baseImpressionModel,
    @JsonKey(name: 'refinement_model') String? refinementModel,
    @JsonKey(name: 'edit_history') List<CaseEditHistoryEntry>? editHistory,
    @JsonKey(name: 'image_urls') List<CaseImageUrl>? imageUrls,
  }) = _CaseDetail;

  factory CaseDetail.fromJson(Map<String, dynamic> json) =>
      _$CaseDetailFromJson(json);

  /// Returns the current impression to display (prioritizes edited over generated over reference)
  String? get currentImpression =>
      editedImpression ?? generatedImpression ?? referenceImpression;

  /// Whether the case has been edited after generation
  bool get wasEdited =>
      editedImpression != null && generatedImpression != null;

  /// Whether a generated impression exists
  bool get hasGenerated => generatedImpression != null;
}
