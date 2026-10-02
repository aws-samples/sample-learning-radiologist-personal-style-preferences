// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Preference _$PreferenceFromJson(Map<String, dynamic> json) {
  return _Preference.fromJson(json);
}

/// @nodoc
mixin _$Preference {
  @JsonKey(name: 'preference_id')
  String get preferenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'preference_text')
  String get preferenceText => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_case_id')
  String get sourceCaseId => throw _privateConstructorUsedError;
  double get timestamp => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  double? get confidence => throw _privateConstructorUsedError;
  @JsonKey(name: 'inference_explanation')
  String? get inferenceExplanation => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_inferred_text')
  String? get originalInferredText => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_edited_at')
  double? get lastEditedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_edit_count')
  int? get userEditCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_edit_id')
  String? get sourceEditId => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_impression')
  String? get originalImpression => throw _privateConstructorUsedError;
  @JsonKey(name: 'edited_impression')
  String? get editedImpression => throw _privateConstructorUsedError;
  @JsonKey(name: 'context_findings')
  String? get contextFindings => throw _privateConstructorUsedError;
  @JsonKey(name: 'edit_distance')
  double? get editDistance => throw _privateConstructorUsedError;
  @JsonKey(name: 'inference_model')
  String? get inferenceModel => throw _privateConstructorUsedError;

  /// Serializes this Preference to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Preference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PreferenceCopyWith<Preference> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreferenceCopyWith<$Res> {
  factory $PreferenceCopyWith(
          Preference value, $Res Function(Preference) then) =
      _$PreferenceCopyWithImpl<$Res, Preference>;
  @useResult
  $Res call(
      {@JsonKey(name: 'preference_id') String preferenceId,
      @JsonKey(name: 'preference_text') String preferenceText,
      @JsonKey(name: 'source_case_id') String sourceCaseId,
      double timestamp,
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
      @JsonKey(name: 'inference_model') String? inferenceModel});
}

/// @nodoc
class _$PreferenceCopyWithImpl<$Res, $Val extends Preference>
    implements $PreferenceCopyWith<$Res> {
  _$PreferenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Preference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferenceId = null,
    Object? preferenceText = null,
    Object? sourceCaseId = null,
    Object? timestamp = null,
    Object? category = freezed,
    Object? confidence = freezed,
    Object? inferenceExplanation = freezed,
    Object? originalInferredText = freezed,
    Object? lastEditedAt = freezed,
    Object? userEditCount = freezed,
    Object? sourceEditId = freezed,
    Object? originalImpression = freezed,
    Object? editedImpression = freezed,
    Object? contextFindings = freezed,
    Object? editDistance = freezed,
    Object? inferenceModel = freezed,
  }) {
    return _then(_value.copyWith(
      preferenceId: null == preferenceId
          ? _value.preferenceId
          : preferenceId // ignore: cast_nullable_to_non_nullable
              as String,
      preferenceText: null == preferenceText
          ? _value.preferenceText
          : preferenceText // ignore: cast_nullable_to_non_nullable
              as String,
      sourceCaseId: null == sourceCaseId
          ? _value.sourceCaseId
          : sourceCaseId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as double,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      inferenceExplanation: freezed == inferenceExplanation
          ? _value.inferenceExplanation
          : inferenceExplanation // ignore: cast_nullable_to_non_nullable
              as String?,
      originalInferredText: freezed == originalInferredText
          ? _value.originalInferredText
          : originalInferredText // ignore: cast_nullable_to_non_nullable
              as String?,
      lastEditedAt: freezed == lastEditedAt
          ? _value.lastEditedAt
          : lastEditedAt // ignore: cast_nullable_to_non_nullable
              as double?,
      userEditCount: freezed == userEditCount
          ? _value.userEditCount
          : userEditCount // ignore: cast_nullable_to_non_nullable
              as int?,
      sourceEditId: freezed == sourceEditId
          ? _value.sourceEditId
          : sourceEditId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalImpression: freezed == originalImpression
          ? _value.originalImpression
          : originalImpression // ignore: cast_nullable_to_non_nullable
              as String?,
      editedImpression: freezed == editedImpression
          ? _value.editedImpression
          : editedImpression // ignore: cast_nullable_to_non_nullable
              as String?,
      contextFindings: freezed == contextFindings
          ? _value.contextFindings
          : contextFindings // ignore: cast_nullable_to_non_nullable
              as String?,
      editDistance: freezed == editDistance
          ? _value.editDistance
          : editDistance // ignore: cast_nullable_to_non_nullable
              as double?,
      inferenceModel: freezed == inferenceModel
          ? _value.inferenceModel
          : inferenceModel // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PreferenceImplCopyWith<$Res>
    implements $PreferenceCopyWith<$Res> {
  factory _$$PreferenceImplCopyWith(
          _$PreferenceImpl value, $Res Function(_$PreferenceImpl) then) =
      __$$PreferenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'preference_id') String preferenceId,
      @JsonKey(name: 'preference_text') String preferenceText,
      @JsonKey(name: 'source_case_id') String sourceCaseId,
      double timestamp,
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
      @JsonKey(name: 'inference_model') String? inferenceModel});
}

/// @nodoc
class __$$PreferenceImplCopyWithImpl<$Res>
    extends _$PreferenceCopyWithImpl<$Res, _$PreferenceImpl>
    implements _$$PreferenceImplCopyWith<$Res> {
  __$$PreferenceImplCopyWithImpl(
      _$PreferenceImpl _value, $Res Function(_$PreferenceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Preference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferenceId = null,
    Object? preferenceText = null,
    Object? sourceCaseId = null,
    Object? timestamp = null,
    Object? category = freezed,
    Object? confidence = freezed,
    Object? inferenceExplanation = freezed,
    Object? originalInferredText = freezed,
    Object? lastEditedAt = freezed,
    Object? userEditCount = freezed,
    Object? sourceEditId = freezed,
    Object? originalImpression = freezed,
    Object? editedImpression = freezed,
    Object? contextFindings = freezed,
    Object? editDistance = freezed,
    Object? inferenceModel = freezed,
  }) {
    return _then(_$PreferenceImpl(
      preferenceId: null == preferenceId
          ? _value.preferenceId
          : preferenceId // ignore: cast_nullable_to_non_nullable
              as String,
      preferenceText: null == preferenceText
          ? _value.preferenceText
          : preferenceText // ignore: cast_nullable_to_non_nullable
              as String,
      sourceCaseId: null == sourceCaseId
          ? _value.sourceCaseId
          : sourceCaseId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as double,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      inferenceExplanation: freezed == inferenceExplanation
          ? _value.inferenceExplanation
          : inferenceExplanation // ignore: cast_nullable_to_non_nullable
              as String?,
      originalInferredText: freezed == originalInferredText
          ? _value.originalInferredText
          : originalInferredText // ignore: cast_nullable_to_non_nullable
              as String?,
      lastEditedAt: freezed == lastEditedAt
          ? _value.lastEditedAt
          : lastEditedAt // ignore: cast_nullable_to_non_nullable
              as double?,
      userEditCount: freezed == userEditCount
          ? _value.userEditCount
          : userEditCount // ignore: cast_nullable_to_non_nullable
              as int?,
      sourceEditId: freezed == sourceEditId
          ? _value.sourceEditId
          : sourceEditId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalImpression: freezed == originalImpression
          ? _value.originalImpression
          : originalImpression // ignore: cast_nullable_to_non_nullable
              as String?,
      editedImpression: freezed == editedImpression
          ? _value.editedImpression
          : editedImpression // ignore: cast_nullable_to_non_nullable
              as String?,
      contextFindings: freezed == contextFindings
          ? _value.contextFindings
          : contextFindings // ignore: cast_nullable_to_non_nullable
              as String?,
      editDistance: freezed == editDistance
          ? _value.editDistance
          : editDistance // ignore: cast_nullable_to_non_nullable
              as double?,
      inferenceModel: freezed == inferenceModel
          ? _value.inferenceModel
          : inferenceModel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PreferenceImpl implements _Preference {
  const _$PreferenceImpl(
      {@JsonKey(name: 'preference_id') this.preferenceId = '',
      @JsonKey(name: 'preference_text') this.preferenceText = '',
      @JsonKey(name: 'source_case_id') this.sourceCaseId = '',
      this.timestamp = 0.0,
      this.category,
      this.confidence,
      @JsonKey(name: 'inference_explanation') this.inferenceExplanation,
      @JsonKey(name: 'original_inferred_text') this.originalInferredText,
      @JsonKey(name: 'last_edited_at') this.lastEditedAt,
      @JsonKey(name: 'user_edit_count') this.userEditCount,
      @JsonKey(name: 'source_edit_id') this.sourceEditId,
      @JsonKey(name: 'original_impression') this.originalImpression,
      @JsonKey(name: 'edited_impression') this.editedImpression,
      @JsonKey(name: 'context_findings') this.contextFindings,
      @JsonKey(name: 'edit_distance') this.editDistance,
      @JsonKey(name: 'inference_model') this.inferenceModel});

  factory _$PreferenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreferenceImplFromJson(json);

  @override
  @JsonKey(name: 'preference_id')
  final String preferenceId;
  @override
  @JsonKey(name: 'preference_text')
  final String preferenceText;
  @override
  @JsonKey(name: 'source_case_id')
  final String sourceCaseId;
  @override
  @JsonKey()
  final double timestamp;
  @override
  final String? category;
  @override
  final double? confidence;
  @override
  @JsonKey(name: 'inference_explanation')
  final String? inferenceExplanation;
  @override
  @JsonKey(name: 'original_inferred_text')
  final String? originalInferredText;
  @override
  @JsonKey(name: 'last_edited_at')
  final double? lastEditedAt;
  @override
  @JsonKey(name: 'user_edit_count')
  final int? userEditCount;
  @override
  @JsonKey(name: 'source_edit_id')
  final String? sourceEditId;
  @override
  @JsonKey(name: 'original_impression')
  final String? originalImpression;
  @override
  @JsonKey(name: 'edited_impression')
  final String? editedImpression;
  @override
  @JsonKey(name: 'context_findings')
  final String? contextFindings;
  @override
  @JsonKey(name: 'edit_distance')
  final double? editDistance;
  @override
  @JsonKey(name: 'inference_model')
  final String? inferenceModel;

  @override
  String toString() {
    return 'Preference(preferenceId: $preferenceId, preferenceText: $preferenceText, sourceCaseId: $sourceCaseId, timestamp: $timestamp, category: $category, confidence: $confidence, inferenceExplanation: $inferenceExplanation, originalInferredText: $originalInferredText, lastEditedAt: $lastEditedAt, userEditCount: $userEditCount, sourceEditId: $sourceEditId, originalImpression: $originalImpression, editedImpression: $editedImpression, contextFindings: $contextFindings, editDistance: $editDistance, inferenceModel: $inferenceModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreferenceImpl &&
            (identical(other.preferenceId, preferenceId) ||
                other.preferenceId == preferenceId) &&
            (identical(other.preferenceText, preferenceText) ||
                other.preferenceText == preferenceText) &&
            (identical(other.sourceCaseId, sourceCaseId) ||
                other.sourceCaseId == sourceCaseId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.inferenceExplanation, inferenceExplanation) ||
                other.inferenceExplanation == inferenceExplanation) &&
            (identical(other.originalInferredText, originalInferredText) ||
                other.originalInferredText == originalInferredText) &&
            (identical(other.lastEditedAt, lastEditedAt) ||
                other.lastEditedAt == lastEditedAt) &&
            (identical(other.userEditCount, userEditCount) ||
                other.userEditCount == userEditCount) &&
            (identical(other.sourceEditId, sourceEditId) ||
                other.sourceEditId == sourceEditId) &&
            (identical(other.originalImpression, originalImpression) ||
                other.originalImpression == originalImpression) &&
            (identical(other.editedImpression, editedImpression) ||
                other.editedImpression == editedImpression) &&
            (identical(other.contextFindings, contextFindings) ||
                other.contextFindings == contextFindings) &&
            (identical(other.editDistance, editDistance) ||
                other.editDistance == editDistance) &&
            (identical(other.inferenceModel, inferenceModel) ||
                other.inferenceModel == inferenceModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      preferenceId,
      preferenceText,
      sourceCaseId,
      timestamp,
      category,
      confidence,
      inferenceExplanation,
      originalInferredText,
      lastEditedAt,
      userEditCount,
      sourceEditId,
      originalImpression,
      editedImpression,
      contextFindings,
      editDistance,
      inferenceModel);

  /// Create a copy of Preference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreferenceImplCopyWith<_$PreferenceImpl> get copyWith =>
      __$$PreferenceImplCopyWithImpl<_$PreferenceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PreferenceImplToJson(
      this,
    );
  }
}

abstract class _Preference implements Preference {
  const factory _Preference(
      {@JsonKey(name: 'preference_id') final String preferenceId,
      @JsonKey(name: 'preference_text') final String preferenceText,
      @JsonKey(name: 'source_case_id') final String sourceCaseId,
      final double timestamp,
      final String? category,
      final double? confidence,
      @JsonKey(name: 'inference_explanation')
      final String? inferenceExplanation,
      @JsonKey(name: 'original_inferred_text')
      final String? originalInferredText,
      @JsonKey(name: 'last_edited_at') final double? lastEditedAt,
      @JsonKey(name: 'user_edit_count') final int? userEditCount,
      @JsonKey(name: 'source_edit_id') final String? sourceEditId,
      @JsonKey(name: 'original_impression') final String? originalImpression,
      @JsonKey(name: 'edited_impression') final String? editedImpression,
      @JsonKey(name: 'context_findings') final String? contextFindings,
      @JsonKey(name: 'edit_distance') final double? editDistance,
      @JsonKey(name: 'inference_model')
      final String? inferenceModel}) = _$PreferenceImpl;

  factory _Preference.fromJson(Map<String, dynamic> json) =
      _$PreferenceImpl.fromJson;

  @override
  @JsonKey(name: 'preference_id')
  String get preferenceId;
  @override
  @JsonKey(name: 'preference_text')
  String get preferenceText;
  @override
  @JsonKey(name: 'source_case_id')
  String get sourceCaseId;
  @override
  double get timestamp;
  @override
  String? get category;
  @override
  double? get confidence;
  @override
  @JsonKey(name: 'inference_explanation')
  String? get inferenceExplanation;
  @override
  @JsonKey(name: 'original_inferred_text')
  String? get originalInferredText;
  @override
  @JsonKey(name: 'last_edited_at')
  double? get lastEditedAt;
  @override
  @JsonKey(name: 'user_edit_count')
  int? get userEditCount;
  @override
  @JsonKey(name: 'source_edit_id')
  String? get sourceEditId;
  @override
  @JsonKey(name: 'original_impression')
  String? get originalImpression;
  @override
  @JsonKey(name: 'edited_impression')
  String? get editedImpression;
  @override
  @JsonKey(name: 'context_findings')
  String? get contextFindings;
  @override
  @JsonKey(name: 'edit_distance')
  double? get editDistance;
  @override
  @JsonKey(name: 'inference_model')
  String? get inferenceModel;

  /// Create a copy of Preference
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreferenceImplCopyWith<_$PreferenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PreferencesResponse _$PreferencesResponseFromJson(Map<String, dynamic> json) {
  return _PreferencesResponse.fromJson(json);
}

/// @nodoc
mixin _$PreferencesResponse {
  int get count => throw _privateConstructorUsedError;
  List<Preference> get preferences => throw _privateConstructorUsedError;

  /// Serializes this PreferencesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PreferencesResponseCopyWith<PreferencesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreferencesResponseCopyWith<$Res> {
  factory $PreferencesResponseCopyWith(
          PreferencesResponse value, $Res Function(PreferencesResponse) then) =
      _$PreferencesResponseCopyWithImpl<$Res, PreferencesResponse>;
  @useResult
  $Res call({int count, List<Preference> preferences});
}

/// @nodoc
class _$PreferencesResponseCopyWithImpl<$Res, $Val extends PreferencesResponse>
    implements $PreferencesResponseCopyWith<$Res> {
  _$PreferencesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? preferences = null,
  }) {
    return _then(_value.copyWith(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as List<Preference>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PreferencesResponseImplCopyWith<$Res>
    implements $PreferencesResponseCopyWith<$Res> {
  factory _$$PreferencesResponseImplCopyWith(_$PreferencesResponseImpl value,
          $Res Function(_$PreferencesResponseImpl) then) =
      __$$PreferencesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int count, List<Preference> preferences});
}

/// @nodoc
class __$$PreferencesResponseImplCopyWithImpl<$Res>
    extends _$PreferencesResponseCopyWithImpl<$Res, _$PreferencesResponseImpl>
    implements _$$PreferencesResponseImplCopyWith<$Res> {
  __$$PreferencesResponseImplCopyWithImpl(_$PreferencesResponseImpl _value,
      $Res Function(_$PreferencesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? preferences = null,
  }) {
    return _then(_$PreferencesResponseImpl(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      preferences: null == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as List<Preference>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PreferencesResponseImpl implements _PreferencesResponse {
  const _$PreferencesResponseImpl(
      {this.count = 0, final List<Preference> preferences = const []})
      : _preferences = preferences;

  factory _$PreferencesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreferencesResponseImplFromJson(json);

  @override
  @JsonKey()
  final int count;
  final List<Preference> _preferences;
  @override
  @JsonKey()
  List<Preference> get preferences {
    if (_preferences is EqualUnmodifiableListView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferences);
  }

  @override
  String toString() {
    return 'PreferencesResponse(count: $count, preferences: $preferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreferencesResponseImpl &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, count, const DeepCollectionEquality().hash(_preferences));

  /// Create a copy of PreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreferencesResponseImplCopyWith<_$PreferencesResponseImpl> get copyWith =>
      __$$PreferencesResponseImplCopyWithImpl<_$PreferencesResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PreferencesResponseImplToJson(
      this,
    );
  }
}

abstract class _PreferencesResponse implements PreferencesResponse {
  const factory _PreferencesResponse(
      {final int count,
      final List<Preference> preferences}) = _$PreferencesResponseImpl;

  factory _PreferencesResponse.fromJson(Map<String, dynamic> json) =
      _$PreferencesResponseImpl.fromJson;

  @override
  int get count;
  @override
  List<Preference> get preferences;

  /// Create a copy of PreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreferencesResponseImplCopyWith<_$PreferencesResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RejectedPreference _$RejectedPreferenceFromJson(Map<String, dynamic> json) {
  return _RejectedPreference.fromJson(json);
}

/// @nodoc
mixin _$RejectedPreference {
  @JsonKey(name: 'rejection_id')
  String get rejectionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'change_description')
  String get changeDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejection_reason')
  String get rejectionReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejection_layer')
  String get rejectionLayer => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_case_id')
  String get sourceCaseId => throw _privateConstructorUsedError;
  double get timestamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'risk_level')
  String? get riskLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'inference_model')
  String? get inferenceModel => throw _privateConstructorUsedError;

  /// Serializes this RejectedPreference to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RejectedPreference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RejectedPreferenceCopyWith<RejectedPreference> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RejectedPreferenceCopyWith<$Res> {
  factory $RejectedPreferenceCopyWith(
          RejectedPreference value, $Res Function(RejectedPreference) then) =
      _$RejectedPreferenceCopyWithImpl<$Res, RejectedPreference>;
  @useResult
  $Res call(
      {@JsonKey(name: 'rejection_id') String rejectionId,
      @JsonKey(name: 'change_description') String changeDescription,
      @JsonKey(name: 'rejection_reason') String rejectionReason,
      @JsonKey(name: 'rejection_layer') String rejectionLayer,
      @JsonKey(name: 'source_case_id') String sourceCaseId,
      double timestamp,
      @JsonKey(name: 'risk_level') String? riskLevel,
      @JsonKey(name: 'inference_model') String? inferenceModel});
}

/// @nodoc
class _$RejectedPreferenceCopyWithImpl<$Res, $Val extends RejectedPreference>
    implements $RejectedPreferenceCopyWith<$Res> {
  _$RejectedPreferenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RejectedPreference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rejectionId = null,
    Object? changeDescription = null,
    Object? rejectionReason = null,
    Object? rejectionLayer = null,
    Object? sourceCaseId = null,
    Object? timestamp = null,
    Object? riskLevel = freezed,
    Object? inferenceModel = freezed,
  }) {
    return _then(_value.copyWith(
      rejectionId: null == rejectionId
          ? _value.rejectionId
          : rejectionId // ignore: cast_nullable_to_non_nullable
              as String,
      changeDescription: null == changeDescription
          ? _value.changeDescription
          : changeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionReason: null == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionLayer: null == rejectionLayer
          ? _value.rejectionLayer
          : rejectionLayer // ignore: cast_nullable_to_non_nullable
              as String,
      sourceCaseId: null == sourceCaseId
          ? _value.sourceCaseId
          : sourceCaseId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as double,
      riskLevel: freezed == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      inferenceModel: freezed == inferenceModel
          ? _value.inferenceModel
          : inferenceModel // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RejectedPreferenceImplCopyWith<$Res>
    implements $RejectedPreferenceCopyWith<$Res> {
  factory _$$RejectedPreferenceImplCopyWith(_$RejectedPreferenceImpl value,
          $Res Function(_$RejectedPreferenceImpl) then) =
      __$$RejectedPreferenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'rejection_id') String rejectionId,
      @JsonKey(name: 'change_description') String changeDescription,
      @JsonKey(name: 'rejection_reason') String rejectionReason,
      @JsonKey(name: 'rejection_layer') String rejectionLayer,
      @JsonKey(name: 'source_case_id') String sourceCaseId,
      double timestamp,
      @JsonKey(name: 'risk_level') String? riskLevel,
      @JsonKey(name: 'inference_model') String? inferenceModel});
}

/// @nodoc
class __$$RejectedPreferenceImplCopyWithImpl<$Res>
    extends _$RejectedPreferenceCopyWithImpl<$Res, _$RejectedPreferenceImpl>
    implements _$$RejectedPreferenceImplCopyWith<$Res> {
  __$$RejectedPreferenceImplCopyWithImpl(_$RejectedPreferenceImpl _value,
      $Res Function(_$RejectedPreferenceImpl) _then)
      : super(_value, _then);

  /// Create a copy of RejectedPreference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rejectionId = null,
    Object? changeDescription = null,
    Object? rejectionReason = null,
    Object? rejectionLayer = null,
    Object? sourceCaseId = null,
    Object? timestamp = null,
    Object? riskLevel = freezed,
    Object? inferenceModel = freezed,
  }) {
    return _then(_$RejectedPreferenceImpl(
      rejectionId: null == rejectionId
          ? _value.rejectionId
          : rejectionId // ignore: cast_nullable_to_non_nullable
              as String,
      changeDescription: null == changeDescription
          ? _value.changeDescription
          : changeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionReason: null == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionLayer: null == rejectionLayer
          ? _value.rejectionLayer
          : rejectionLayer // ignore: cast_nullable_to_non_nullable
              as String,
      sourceCaseId: null == sourceCaseId
          ? _value.sourceCaseId
          : sourceCaseId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as double,
      riskLevel: freezed == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      inferenceModel: freezed == inferenceModel
          ? _value.inferenceModel
          : inferenceModel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RejectedPreferenceImpl implements _RejectedPreference {
  const _$RejectedPreferenceImpl(
      {@JsonKey(name: 'rejection_id') this.rejectionId = '',
      @JsonKey(name: 'change_description') this.changeDescription = '',
      @JsonKey(name: 'rejection_reason') this.rejectionReason = '',
      @JsonKey(name: 'rejection_layer') this.rejectionLayer = '',
      @JsonKey(name: 'source_case_id') this.sourceCaseId = '',
      this.timestamp = 0.0,
      @JsonKey(name: 'risk_level') this.riskLevel,
      @JsonKey(name: 'inference_model') this.inferenceModel});

  factory _$RejectedPreferenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$RejectedPreferenceImplFromJson(json);

  @override
  @JsonKey(name: 'rejection_id')
  final String rejectionId;
  @override
  @JsonKey(name: 'change_description')
  final String changeDescription;
  @override
  @JsonKey(name: 'rejection_reason')
  final String rejectionReason;
  @override
  @JsonKey(name: 'rejection_layer')
  final String rejectionLayer;
  @override
  @JsonKey(name: 'source_case_id')
  final String sourceCaseId;
  @override
  @JsonKey()
  final double timestamp;
  @override
  @JsonKey(name: 'risk_level')
  final String? riskLevel;
  @override
  @JsonKey(name: 'inference_model')
  final String? inferenceModel;

  @override
  String toString() {
    return 'RejectedPreference(rejectionId: $rejectionId, changeDescription: $changeDescription, rejectionReason: $rejectionReason, rejectionLayer: $rejectionLayer, sourceCaseId: $sourceCaseId, timestamp: $timestamp, riskLevel: $riskLevel, inferenceModel: $inferenceModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RejectedPreferenceImpl &&
            (identical(other.rejectionId, rejectionId) ||
                other.rejectionId == rejectionId) &&
            (identical(other.changeDescription, changeDescription) ||
                other.changeDescription == changeDescription) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.rejectionLayer, rejectionLayer) ||
                other.rejectionLayer == rejectionLayer) &&
            (identical(other.sourceCaseId, sourceCaseId) ||
                other.sourceCaseId == sourceCaseId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            (identical(other.inferenceModel, inferenceModel) ||
                other.inferenceModel == inferenceModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      rejectionId,
      changeDescription,
      rejectionReason,
      rejectionLayer,
      sourceCaseId,
      timestamp,
      riskLevel,
      inferenceModel);

  /// Create a copy of RejectedPreference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RejectedPreferenceImplCopyWith<_$RejectedPreferenceImpl> get copyWith =>
      __$$RejectedPreferenceImplCopyWithImpl<_$RejectedPreferenceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RejectedPreferenceImplToJson(
      this,
    );
  }
}

abstract class _RejectedPreference implements RejectedPreference {
  const factory _RejectedPreference(
          {@JsonKey(name: 'rejection_id') final String rejectionId,
          @JsonKey(name: 'change_description') final String changeDescription,
          @JsonKey(name: 'rejection_reason') final String rejectionReason,
          @JsonKey(name: 'rejection_layer') final String rejectionLayer,
          @JsonKey(name: 'source_case_id') final String sourceCaseId,
          final double timestamp,
          @JsonKey(name: 'risk_level') final String? riskLevel,
          @JsonKey(name: 'inference_model') final String? inferenceModel}) =
      _$RejectedPreferenceImpl;

  factory _RejectedPreference.fromJson(Map<String, dynamic> json) =
      _$RejectedPreferenceImpl.fromJson;

  @override
  @JsonKey(name: 'rejection_id')
  String get rejectionId;
  @override
  @JsonKey(name: 'change_description')
  String get changeDescription;
  @override
  @JsonKey(name: 'rejection_reason')
  String get rejectionReason;
  @override
  @JsonKey(name: 'rejection_layer')
  String get rejectionLayer;
  @override
  @JsonKey(name: 'source_case_id')
  String get sourceCaseId;
  @override
  double get timestamp;
  @override
  @JsonKey(name: 'risk_level')
  String? get riskLevel;
  @override
  @JsonKey(name: 'inference_model')
  String? get inferenceModel;

  /// Create a copy of RejectedPreference
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RejectedPreferenceImplCopyWith<_$RejectedPreferenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RejectedPreferencesResponse _$RejectedPreferencesResponseFromJson(
    Map<String, dynamic> json) {
  return _RejectedPreferencesResponse.fromJson(json);
}

/// @nodoc
mixin _$RejectedPreferencesResponse {
  int get count => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejected_preferences')
  List<RejectedPreference> get rejectedPreferences =>
      throw _privateConstructorUsedError;

  /// Serializes this RejectedPreferencesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RejectedPreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RejectedPreferencesResponseCopyWith<RejectedPreferencesResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RejectedPreferencesResponseCopyWith<$Res> {
  factory $RejectedPreferencesResponseCopyWith(
          RejectedPreferencesResponse value,
          $Res Function(RejectedPreferencesResponse) then) =
      _$RejectedPreferencesResponseCopyWithImpl<$Res,
          RejectedPreferencesResponse>;
  @useResult
  $Res call(
      {int count,
      @JsonKey(name: 'rejected_preferences')
      List<RejectedPreference> rejectedPreferences});
}

/// @nodoc
class _$RejectedPreferencesResponseCopyWithImpl<$Res,
        $Val extends RejectedPreferencesResponse>
    implements $RejectedPreferencesResponseCopyWith<$Res> {
  _$RejectedPreferencesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RejectedPreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? rejectedPreferences = null,
  }) {
    return _then(_value.copyWith(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      rejectedPreferences: null == rejectedPreferences
          ? _value.rejectedPreferences
          : rejectedPreferences // ignore: cast_nullable_to_non_nullable
              as List<RejectedPreference>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RejectedPreferencesResponseImplCopyWith<$Res>
    implements $RejectedPreferencesResponseCopyWith<$Res> {
  factory _$$RejectedPreferencesResponseImplCopyWith(
          _$RejectedPreferencesResponseImpl value,
          $Res Function(_$RejectedPreferencesResponseImpl) then) =
      __$$RejectedPreferencesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int count,
      @JsonKey(name: 'rejected_preferences')
      List<RejectedPreference> rejectedPreferences});
}

/// @nodoc
class __$$RejectedPreferencesResponseImplCopyWithImpl<$Res>
    extends _$RejectedPreferencesResponseCopyWithImpl<$Res,
        _$RejectedPreferencesResponseImpl>
    implements _$$RejectedPreferencesResponseImplCopyWith<$Res> {
  __$$RejectedPreferencesResponseImplCopyWithImpl(
      _$RejectedPreferencesResponseImpl _value,
      $Res Function(_$RejectedPreferencesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RejectedPreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? rejectedPreferences = null,
  }) {
    return _then(_$RejectedPreferencesResponseImpl(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      rejectedPreferences: null == rejectedPreferences
          ? _value._rejectedPreferences
          : rejectedPreferences // ignore: cast_nullable_to_non_nullable
              as List<RejectedPreference>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RejectedPreferencesResponseImpl
    implements _RejectedPreferencesResponse {
  const _$RejectedPreferencesResponseImpl(
      {this.count = 0,
      @JsonKey(name: 'rejected_preferences')
      final List<RejectedPreference> rejectedPreferences = const []})
      : _rejectedPreferences = rejectedPreferences;

  factory _$RejectedPreferencesResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RejectedPreferencesResponseImplFromJson(json);

  @override
  @JsonKey()
  final int count;
  final List<RejectedPreference> _rejectedPreferences;
  @override
  @JsonKey(name: 'rejected_preferences')
  List<RejectedPreference> get rejectedPreferences {
    if (_rejectedPreferences is EqualUnmodifiableListView)
      return _rejectedPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rejectedPreferences);
  }

  @override
  String toString() {
    return 'RejectedPreferencesResponse(count: $count, rejectedPreferences: $rejectedPreferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RejectedPreferencesResponseImpl &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality()
                .equals(other._rejectedPreferences, _rejectedPreferences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count,
      const DeepCollectionEquality().hash(_rejectedPreferences));

  /// Create a copy of RejectedPreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RejectedPreferencesResponseImplCopyWith<_$RejectedPreferencesResponseImpl>
      get copyWith => __$$RejectedPreferencesResponseImplCopyWithImpl<
          _$RejectedPreferencesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RejectedPreferencesResponseImplToJson(
      this,
    );
  }
}

abstract class _RejectedPreferencesResponse
    implements RejectedPreferencesResponse {
  const factory _RejectedPreferencesResponse(
          {final int count,
          @JsonKey(name: 'rejected_preferences')
          final List<RejectedPreference> rejectedPreferences}) =
      _$RejectedPreferencesResponseImpl;

  factory _RejectedPreferencesResponse.fromJson(Map<String, dynamic> json) =
      _$RejectedPreferencesResponseImpl.fromJson;

  @override
  int get count;
  @override
  @JsonKey(name: 'rejected_preferences')
  List<RejectedPreference> get rejectedPreferences;

  /// Create a copy of RejectedPreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RejectedPreferencesResponseImplCopyWith<_$RejectedPreferencesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
