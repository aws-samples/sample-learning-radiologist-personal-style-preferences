// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'case.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Case _$CaseFromJson(Map<String, dynamic> json) {
  return _Case.fromJson(json);
}

/// @nodoc
mixin _$Case {
  @JsonKey(name: 'case_id')
  String get caseId => throw _privateConstructorUsedError;
  String get findings => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_generated')
  bool get hasGenerated => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_edited')
  bool get hasEdited => throw _privateConstructorUsedError;

  /// Serializes this Case to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Case
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaseCopyWith<Case> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaseCopyWith<$Res> {
  factory $CaseCopyWith(Case value, $Res Function(Case) then) =
      _$CaseCopyWithImpl<$Res, Case>;
  @useResult
  $Res call(
      {@JsonKey(name: 'case_id') String caseId,
      String findings,
      @JsonKey(name: 'has_generated') bool hasGenerated,
      @JsonKey(name: 'has_edited') bool hasEdited});
}

/// @nodoc
class _$CaseCopyWithImpl<$Res, $Val extends Case>
    implements $CaseCopyWith<$Res> {
  _$CaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Case
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caseId = null,
    Object? findings = null,
    Object? hasGenerated = null,
    Object? hasEdited = null,
  }) {
    return _then(_value.copyWith(
      caseId: null == caseId
          ? _value.caseId
          : caseId // ignore: cast_nullable_to_non_nullable
              as String,
      findings: null == findings
          ? _value.findings
          : findings // ignore: cast_nullable_to_non_nullable
              as String,
      hasGenerated: null == hasGenerated
          ? _value.hasGenerated
          : hasGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      hasEdited: null == hasEdited
          ? _value.hasEdited
          : hasEdited // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CaseImplCopyWith<$Res> implements $CaseCopyWith<$Res> {
  factory _$$CaseImplCopyWith(
          _$CaseImpl value, $Res Function(_$CaseImpl) then) =
      __$$CaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'case_id') String caseId,
      String findings,
      @JsonKey(name: 'has_generated') bool hasGenerated,
      @JsonKey(name: 'has_edited') bool hasEdited});
}

/// @nodoc
class __$$CaseImplCopyWithImpl<$Res>
    extends _$CaseCopyWithImpl<$Res, _$CaseImpl>
    implements _$$CaseImplCopyWith<$Res> {
  __$$CaseImplCopyWithImpl(_$CaseImpl _value, $Res Function(_$CaseImpl) _then)
      : super(_value, _then);

  /// Create a copy of Case
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caseId = null,
    Object? findings = null,
    Object? hasGenerated = null,
    Object? hasEdited = null,
  }) {
    return _then(_$CaseImpl(
      caseId: null == caseId
          ? _value.caseId
          : caseId // ignore: cast_nullable_to_non_nullable
              as String,
      findings: null == findings
          ? _value.findings
          : findings // ignore: cast_nullable_to_non_nullable
              as String,
      hasGenerated: null == hasGenerated
          ? _value.hasGenerated
          : hasGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      hasEdited: null == hasEdited
          ? _value.hasEdited
          : hasEdited // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CaseImpl implements _Case {
  const _$CaseImpl(
      {@JsonKey(name: 'case_id') this.caseId = '',
      this.findings = '',
      @JsonKey(name: 'has_generated') this.hasGenerated = false,
      @JsonKey(name: 'has_edited') this.hasEdited = false});

  factory _$CaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaseImplFromJson(json);

  @override
  @JsonKey(name: 'case_id')
  final String caseId;
  @override
  @JsonKey()
  final String findings;
  @override
  @JsonKey(name: 'has_generated')
  final bool hasGenerated;
  @override
  @JsonKey(name: 'has_edited')
  final bool hasEdited;

  @override
  String toString() {
    return 'Case(caseId: $caseId, findings: $findings, hasGenerated: $hasGenerated, hasEdited: $hasEdited)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaseImpl &&
            (identical(other.caseId, caseId) || other.caseId == caseId) &&
            (identical(other.findings, findings) ||
                other.findings == findings) &&
            (identical(other.hasGenerated, hasGenerated) ||
                other.hasGenerated == hasGenerated) &&
            (identical(other.hasEdited, hasEdited) ||
                other.hasEdited == hasEdited));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, caseId, findings, hasGenerated, hasEdited);

  /// Create a copy of Case
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaseImplCopyWith<_$CaseImpl> get copyWith =>
      __$$CaseImplCopyWithImpl<_$CaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CaseImplToJson(
      this,
    );
  }
}

abstract class _Case implements Case {
  const factory _Case(
      {@JsonKey(name: 'case_id') final String caseId,
      final String findings,
      @JsonKey(name: 'has_generated') final bool hasGenerated,
      @JsonKey(name: 'has_edited') final bool hasEdited}) = _$CaseImpl;

  factory _Case.fromJson(Map<String, dynamic> json) = _$CaseImpl.fromJson;

  @override
  @JsonKey(name: 'case_id')
  String get caseId;
  @override
  String get findings;
  @override
  @JsonKey(name: 'has_generated')
  bool get hasGenerated;
  @override
  @JsonKey(name: 'has_edited')
  bool get hasEdited;

  /// Create a copy of Case
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaseImplCopyWith<_$CaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CasesResponse _$CasesResponseFromJson(Map<String, dynamic> json) {
  return _CasesResponse.fromJson(json);
}

/// @nodoc
mixin _$CasesResponse {
  int get count => throw _privateConstructorUsedError;
  List<Case> get cases => throw _privateConstructorUsedError;

  /// Serializes this CasesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CasesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CasesResponseCopyWith<CasesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CasesResponseCopyWith<$Res> {
  factory $CasesResponseCopyWith(
          CasesResponse value, $Res Function(CasesResponse) then) =
      _$CasesResponseCopyWithImpl<$Res, CasesResponse>;
  @useResult
  $Res call({int count, List<Case> cases});
}

/// @nodoc
class _$CasesResponseCopyWithImpl<$Res, $Val extends CasesResponse>
    implements $CasesResponseCopyWith<$Res> {
  _$CasesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CasesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? cases = null,
  }) {
    return _then(_value.copyWith(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      cases: null == cases
          ? _value.cases
          : cases // ignore: cast_nullable_to_non_nullable
              as List<Case>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CasesResponseImplCopyWith<$Res>
    implements $CasesResponseCopyWith<$Res> {
  factory _$$CasesResponseImplCopyWith(
          _$CasesResponseImpl value, $Res Function(_$CasesResponseImpl) then) =
      __$$CasesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int count, List<Case> cases});
}

/// @nodoc
class __$$CasesResponseImplCopyWithImpl<$Res>
    extends _$CasesResponseCopyWithImpl<$Res, _$CasesResponseImpl>
    implements _$$CasesResponseImplCopyWith<$Res> {
  __$$CasesResponseImplCopyWithImpl(
      _$CasesResponseImpl _value, $Res Function(_$CasesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CasesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? cases = null,
  }) {
    return _then(_$CasesResponseImpl(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      cases: null == cases
          ? _value._cases
          : cases // ignore: cast_nullable_to_non_nullable
              as List<Case>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CasesResponseImpl implements _CasesResponse {
  const _$CasesResponseImpl({this.count = 0, final List<Case> cases = const []})
      : _cases = cases;

  factory _$CasesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CasesResponseImplFromJson(json);

  @override
  @JsonKey()
  final int count;
  final List<Case> _cases;
  @override
  @JsonKey()
  List<Case> get cases {
    if (_cases is EqualUnmodifiableListView) return _cases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cases);
  }

  @override
  String toString() {
    return 'CasesResponse(count: $count, cases: $cases)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CasesResponseImpl &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality().equals(other._cases, _cases));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, count, const DeepCollectionEquality().hash(_cases));

  /// Create a copy of CasesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CasesResponseImplCopyWith<_$CasesResponseImpl> get copyWith =>
      __$$CasesResponseImplCopyWithImpl<_$CasesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CasesResponseImplToJson(
      this,
    );
  }
}

abstract class _CasesResponse implements CasesResponse {
  const factory _CasesResponse({final int count, final List<Case> cases}) =
      _$CasesResponseImpl;

  factory _CasesResponse.fromJson(Map<String, dynamic> json) =
      _$CasesResponseImpl.fromJson;

  @override
  int get count;
  @override
  List<Case> get cases;

  /// Create a copy of CasesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CasesResponseImplCopyWith<_$CasesResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CaseAppliedPreference _$CaseAppliedPreferenceFromJson(
    Map<String, dynamic> json) {
  return _CaseAppliedPreference.fromJson(json);
}

/// @nodoc
mixin _$CaseAppliedPreference {
  @JsonKey(name: 'preference_id')
  String get preferenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'preference_text')
  String get preferenceText => throw _privateConstructorUsedError;

  /// Serializes this CaseAppliedPreference to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CaseAppliedPreference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaseAppliedPreferenceCopyWith<CaseAppliedPreference> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaseAppliedPreferenceCopyWith<$Res> {
  factory $CaseAppliedPreferenceCopyWith(CaseAppliedPreference value,
          $Res Function(CaseAppliedPreference) then) =
      _$CaseAppliedPreferenceCopyWithImpl<$Res, CaseAppliedPreference>;
  @useResult
  $Res call(
      {@JsonKey(name: 'preference_id') String preferenceId,
      @JsonKey(name: 'preference_text') String preferenceText});
}

/// @nodoc
class _$CaseAppliedPreferenceCopyWithImpl<$Res,
        $Val extends CaseAppliedPreference>
    implements $CaseAppliedPreferenceCopyWith<$Res> {
  _$CaseAppliedPreferenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaseAppliedPreference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferenceId = null,
    Object? preferenceText = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CaseAppliedPreferenceImplCopyWith<$Res>
    implements $CaseAppliedPreferenceCopyWith<$Res> {
  factory _$$CaseAppliedPreferenceImplCopyWith(
          _$CaseAppliedPreferenceImpl value,
          $Res Function(_$CaseAppliedPreferenceImpl) then) =
      __$$CaseAppliedPreferenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'preference_id') String preferenceId,
      @JsonKey(name: 'preference_text') String preferenceText});
}

/// @nodoc
class __$$CaseAppliedPreferenceImplCopyWithImpl<$Res>
    extends _$CaseAppliedPreferenceCopyWithImpl<$Res,
        _$CaseAppliedPreferenceImpl>
    implements _$$CaseAppliedPreferenceImplCopyWith<$Res> {
  __$$CaseAppliedPreferenceImplCopyWithImpl(_$CaseAppliedPreferenceImpl _value,
      $Res Function(_$CaseAppliedPreferenceImpl) _then)
      : super(_value, _then);

  /// Create a copy of CaseAppliedPreference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferenceId = null,
    Object? preferenceText = null,
  }) {
    return _then(_$CaseAppliedPreferenceImpl(
      preferenceId: null == preferenceId
          ? _value.preferenceId
          : preferenceId // ignore: cast_nullable_to_non_nullable
              as String,
      preferenceText: null == preferenceText
          ? _value.preferenceText
          : preferenceText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CaseAppliedPreferenceImpl implements _CaseAppliedPreference {
  const _$CaseAppliedPreferenceImpl(
      {@JsonKey(name: 'preference_id') this.preferenceId = '',
      @JsonKey(name: 'preference_text') this.preferenceText = ''});

  factory _$CaseAppliedPreferenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaseAppliedPreferenceImplFromJson(json);

  @override
  @JsonKey(name: 'preference_id')
  final String preferenceId;
  @override
  @JsonKey(name: 'preference_text')
  final String preferenceText;

  @override
  String toString() {
    return 'CaseAppliedPreference(preferenceId: $preferenceId, preferenceText: $preferenceText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaseAppliedPreferenceImpl &&
            (identical(other.preferenceId, preferenceId) ||
                other.preferenceId == preferenceId) &&
            (identical(other.preferenceText, preferenceText) ||
                other.preferenceText == preferenceText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, preferenceId, preferenceText);

  /// Create a copy of CaseAppliedPreference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaseAppliedPreferenceImplCopyWith<_$CaseAppliedPreferenceImpl>
      get copyWith => __$$CaseAppliedPreferenceImplCopyWithImpl<
          _$CaseAppliedPreferenceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CaseAppliedPreferenceImplToJson(
      this,
    );
  }
}

abstract class _CaseAppliedPreference implements CaseAppliedPreference {
  const factory _CaseAppliedPreference(
          {@JsonKey(name: 'preference_id') final String preferenceId,
          @JsonKey(name: 'preference_text') final String preferenceText}) =
      _$CaseAppliedPreferenceImpl;

  factory _CaseAppliedPreference.fromJson(Map<String, dynamic> json) =
      _$CaseAppliedPreferenceImpl.fromJson;

  @override
  @JsonKey(name: 'preference_id')
  String get preferenceId;
  @override
  @JsonKey(name: 'preference_text')
  String get preferenceText;

  /// Create a copy of CaseAppliedPreference
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaseAppliedPreferenceImplCopyWith<_$CaseAppliedPreferenceImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CaseImageUrl _$CaseImageUrlFromJson(Map<String, dynamic> json) {
  return _CaseImageUrl.fromJson(json);
}

/// @nodoc
mixin _$CaseImageUrl {
  String get view => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  double? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this CaseImageUrl to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CaseImageUrl
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaseImageUrlCopyWith<CaseImageUrl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaseImageUrlCopyWith<$Res> {
  factory $CaseImageUrlCopyWith(
          CaseImageUrl value, $Res Function(CaseImageUrl) then) =
      _$CaseImageUrlCopyWithImpl<$Res, CaseImageUrl>;
  @useResult
  $Res call(
      {String view,
      String url,
      @JsonKey(name: 'expires_at') double? expiresAt});
}

/// @nodoc
class _$CaseImageUrlCopyWithImpl<$Res, $Val extends CaseImageUrl>
    implements $CaseImageUrlCopyWith<$Res> {
  _$CaseImageUrlCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaseImageUrl
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? view = null,
    Object? url = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      view: null == view
          ? _value.view
          : view // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CaseImageUrlImplCopyWith<$Res>
    implements $CaseImageUrlCopyWith<$Res> {
  factory _$$CaseImageUrlImplCopyWith(
          _$CaseImageUrlImpl value, $Res Function(_$CaseImageUrlImpl) then) =
      __$$CaseImageUrlImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String view,
      String url,
      @JsonKey(name: 'expires_at') double? expiresAt});
}

/// @nodoc
class __$$CaseImageUrlImplCopyWithImpl<$Res>
    extends _$CaseImageUrlCopyWithImpl<$Res, _$CaseImageUrlImpl>
    implements _$$CaseImageUrlImplCopyWith<$Res> {
  __$$CaseImageUrlImplCopyWithImpl(
      _$CaseImageUrlImpl _value, $Res Function(_$CaseImageUrlImpl) _then)
      : super(_value, _then);

  /// Create a copy of CaseImageUrl
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? view = null,
    Object? url = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_$CaseImageUrlImpl(
      view: null == view
          ? _value.view
          : view // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CaseImageUrlImpl implements _CaseImageUrl {
  const _$CaseImageUrlImpl(
      {this.view = '',
      this.url = '',
      @JsonKey(name: 'expires_at') this.expiresAt});

  factory _$CaseImageUrlImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaseImageUrlImplFromJson(json);

  @override
  @JsonKey()
  final String view;
  @override
  @JsonKey()
  final String url;
  @override
  @JsonKey(name: 'expires_at')
  final double? expiresAt;

  @override
  String toString() {
    return 'CaseImageUrl(view: $view, url: $url, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaseImageUrlImpl &&
            (identical(other.view, view) || other.view == view) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, view, url, expiresAt);

  /// Create a copy of CaseImageUrl
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaseImageUrlImplCopyWith<_$CaseImageUrlImpl> get copyWith =>
      __$$CaseImageUrlImplCopyWithImpl<_$CaseImageUrlImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CaseImageUrlImplToJson(
      this,
    );
  }
}

abstract class _CaseImageUrl implements CaseImageUrl {
  const factory _CaseImageUrl(
          {final String view,
          final String url,
          @JsonKey(name: 'expires_at') final double? expiresAt}) =
      _$CaseImageUrlImpl;

  factory _CaseImageUrl.fromJson(Map<String, dynamic> json) =
      _$CaseImageUrlImpl.fromJson;

  @override
  String get view;
  @override
  String get url;
  @override
  @JsonKey(name: 'expires_at')
  double? get expiresAt;

  /// Create a copy of CaseImageUrl
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaseImageUrlImplCopyWith<_$CaseImageUrlImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CaseEditHistoryEntry _$CaseEditHistoryEntryFromJson(Map<String, dynamic> json) {
  return _CaseEditHistoryEntry.fromJson(json);
}

/// @nodoc
mixin _$CaseEditHistoryEntry {
  @JsonKey(name: 'edit_id')
  String get editId => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_impression')
  String get originalImpression => throw _privateConstructorUsedError;
  @JsonKey(name: 'edited_impression')
  String get editedImpression => throw _privateConstructorUsedError;
  @JsonKey(name: 'edit_distance')
  double get editDistance => throw _privateConstructorUsedError;
  double get timestamp => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferences_snapshot')
  List<CaseAppliedPreference>? get preferencesSnapshot =>
      throw _privateConstructorUsedError;

  /// Serializes this CaseEditHistoryEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CaseEditHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaseEditHistoryEntryCopyWith<CaseEditHistoryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaseEditHistoryEntryCopyWith<$Res> {
  factory $CaseEditHistoryEntryCopyWith(CaseEditHistoryEntry value,
          $Res Function(CaseEditHistoryEntry) then) =
      _$CaseEditHistoryEntryCopyWithImpl<$Res, CaseEditHistoryEntry>;
  @useResult
  $Res call(
      {@JsonKey(name: 'edit_id') String editId,
      @JsonKey(name: 'original_impression') String originalImpression,
      @JsonKey(name: 'edited_impression') String editedImpression,
      @JsonKey(name: 'edit_distance') double editDistance,
      double timestamp,
      String source,
      @JsonKey(name: 'preferences_snapshot')
      List<CaseAppliedPreference>? preferencesSnapshot});
}

/// @nodoc
class _$CaseEditHistoryEntryCopyWithImpl<$Res,
        $Val extends CaseEditHistoryEntry>
    implements $CaseEditHistoryEntryCopyWith<$Res> {
  _$CaseEditHistoryEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaseEditHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? editId = null,
    Object? originalImpression = null,
    Object? editedImpression = null,
    Object? editDistance = null,
    Object? timestamp = null,
    Object? source = null,
    Object? preferencesSnapshot = freezed,
  }) {
    return _then(_value.copyWith(
      editId: null == editId
          ? _value.editId
          : editId // ignore: cast_nullable_to_non_nullable
              as String,
      originalImpression: null == originalImpression
          ? _value.originalImpression
          : originalImpression // ignore: cast_nullable_to_non_nullable
              as String,
      editedImpression: null == editedImpression
          ? _value.editedImpression
          : editedImpression // ignore: cast_nullable_to_non_nullable
              as String,
      editDistance: null == editDistance
          ? _value.editDistance
          : editDistance // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as double,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      preferencesSnapshot: freezed == preferencesSnapshot
          ? _value.preferencesSnapshot
          : preferencesSnapshot // ignore: cast_nullable_to_non_nullable
              as List<CaseAppliedPreference>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CaseEditHistoryEntryImplCopyWith<$Res>
    implements $CaseEditHistoryEntryCopyWith<$Res> {
  factory _$$CaseEditHistoryEntryImplCopyWith(_$CaseEditHistoryEntryImpl value,
          $Res Function(_$CaseEditHistoryEntryImpl) then) =
      __$$CaseEditHistoryEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'edit_id') String editId,
      @JsonKey(name: 'original_impression') String originalImpression,
      @JsonKey(name: 'edited_impression') String editedImpression,
      @JsonKey(name: 'edit_distance') double editDistance,
      double timestamp,
      String source,
      @JsonKey(name: 'preferences_snapshot')
      List<CaseAppliedPreference>? preferencesSnapshot});
}

/// @nodoc
class __$$CaseEditHistoryEntryImplCopyWithImpl<$Res>
    extends _$CaseEditHistoryEntryCopyWithImpl<$Res, _$CaseEditHistoryEntryImpl>
    implements _$$CaseEditHistoryEntryImplCopyWith<$Res> {
  __$$CaseEditHistoryEntryImplCopyWithImpl(_$CaseEditHistoryEntryImpl _value,
      $Res Function(_$CaseEditHistoryEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of CaseEditHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? editId = null,
    Object? originalImpression = null,
    Object? editedImpression = null,
    Object? editDistance = null,
    Object? timestamp = null,
    Object? source = null,
    Object? preferencesSnapshot = freezed,
  }) {
    return _then(_$CaseEditHistoryEntryImpl(
      editId: null == editId
          ? _value.editId
          : editId // ignore: cast_nullable_to_non_nullable
              as String,
      originalImpression: null == originalImpression
          ? _value.originalImpression
          : originalImpression // ignore: cast_nullable_to_non_nullable
              as String,
      editedImpression: null == editedImpression
          ? _value.editedImpression
          : editedImpression // ignore: cast_nullable_to_non_nullable
              as String,
      editDistance: null == editDistance
          ? _value.editDistance
          : editDistance // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as double,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      preferencesSnapshot: freezed == preferencesSnapshot
          ? _value._preferencesSnapshot
          : preferencesSnapshot // ignore: cast_nullable_to_non_nullable
              as List<CaseAppliedPreference>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CaseEditHistoryEntryImpl implements _CaseEditHistoryEntry {
  const _$CaseEditHistoryEntryImpl(
      {@JsonKey(name: 'edit_id') this.editId = '',
      @JsonKey(name: 'original_impression') this.originalImpression = '',
      @JsonKey(name: 'edited_impression') this.editedImpression = '',
      @JsonKey(name: 'edit_distance') this.editDistance = 0.0,
      this.timestamp = 0.0,
      this.source = 'unknown',
      @JsonKey(name: 'preferences_snapshot')
      final List<CaseAppliedPreference>? preferencesSnapshot})
      : _preferencesSnapshot = preferencesSnapshot;

  factory _$CaseEditHistoryEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaseEditHistoryEntryImplFromJson(json);

  @override
  @JsonKey(name: 'edit_id')
  final String editId;
  @override
  @JsonKey(name: 'original_impression')
  final String originalImpression;
  @override
  @JsonKey(name: 'edited_impression')
  final String editedImpression;
  @override
  @JsonKey(name: 'edit_distance')
  final double editDistance;
  @override
  @JsonKey()
  final double timestamp;
  @override
  @JsonKey()
  final String source;
  final List<CaseAppliedPreference>? _preferencesSnapshot;
  @override
  @JsonKey(name: 'preferences_snapshot')
  List<CaseAppliedPreference>? get preferencesSnapshot {
    final value = _preferencesSnapshot;
    if (value == null) return null;
    if (_preferencesSnapshot is EqualUnmodifiableListView)
      return _preferencesSnapshot;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CaseEditHistoryEntry(editId: $editId, originalImpression: $originalImpression, editedImpression: $editedImpression, editDistance: $editDistance, timestamp: $timestamp, source: $source, preferencesSnapshot: $preferencesSnapshot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaseEditHistoryEntryImpl &&
            (identical(other.editId, editId) || other.editId == editId) &&
            (identical(other.originalImpression, originalImpression) ||
                other.originalImpression == originalImpression) &&
            (identical(other.editedImpression, editedImpression) ||
                other.editedImpression == editedImpression) &&
            (identical(other.editDistance, editDistance) ||
                other.editDistance == editDistance) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality()
                .equals(other._preferencesSnapshot, _preferencesSnapshot));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      editId,
      originalImpression,
      editedImpression,
      editDistance,
      timestamp,
      source,
      const DeepCollectionEquality().hash(_preferencesSnapshot));

  /// Create a copy of CaseEditHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaseEditHistoryEntryImplCopyWith<_$CaseEditHistoryEntryImpl>
      get copyWith =>
          __$$CaseEditHistoryEntryImplCopyWithImpl<_$CaseEditHistoryEntryImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CaseEditHistoryEntryImplToJson(
      this,
    );
  }
}

abstract class _CaseEditHistoryEntry implements CaseEditHistoryEntry {
  const factory _CaseEditHistoryEntry(
          {@JsonKey(name: 'edit_id') final String editId,
          @JsonKey(name: 'original_impression') final String originalImpression,
          @JsonKey(name: 'edited_impression') final String editedImpression,
          @JsonKey(name: 'edit_distance') final double editDistance,
          final double timestamp,
          final String source,
          @JsonKey(name: 'preferences_snapshot')
          final List<CaseAppliedPreference>? preferencesSnapshot}) =
      _$CaseEditHistoryEntryImpl;

  factory _CaseEditHistoryEntry.fromJson(Map<String, dynamic> json) =
      _$CaseEditHistoryEntryImpl.fromJson;

  @override
  @JsonKey(name: 'edit_id')
  String get editId;
  @override
  @JsonKey(name: 'original_impression')
  String get originalImpression;
  @override
  @JsonKey(name: 'edited_impression')
  String get editedImpression;
  @override
  @JsonKey(name: 'edit_distance')
  double get editDistance;
  @override
  double get timestamp;
  @override
  String get source;
  @override
  @JsonKey(name: 'preferences_snapshot')
  List<CaseAppliedPreference>? get preferencesSnapshot;

  /// Create a copy of CaseEditHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaseEditHistoryEntryImplCopyWith<_$CaseEditHistoryEntryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CaseDetail _$CaseDetailFromJson(Map<String, dynamic> json) {
  return _CaseDetail.fromJson(json);
}

/// @nodoc
mixin _$CaseDetail {
  @JsonKey(name: 'case_id')
  String get caseId => throw _privateConstructorUsedError;
  String get findings => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_impression')
  String? get referenceImpression => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_impression')
  String? get generatedImpression => throw _privateConstructorUsedError;
  @JsonKey(name: 'edited_impression')
  String? get editedImpression => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at')
  double? get generatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'edited_at')
  double? get editedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_impression')
  String? get baseImpression => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferences_applied')
  List<CaseAppliedPreference>? get preferencesApplied =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'base_impression_model')
  String? get baseImpressionModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'refinement_model')
  String? get refinementModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'edit_history')
  List<CaseEditHistoryEntry>? get editHistory =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'image_urls')
  List<CaseImageUrl>? get imageUrls => throw _privateConstructorUsedError;

  /// Serializes this CaseDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CaseDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaseDetailCopyWith<CaseDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaseDetailCopyWith<$Res> {
  factory $CaseDetailCopyWith(
          CaseDetail value, $Res Function(CaseDetail) then) =
      _$CaseDetailCopyWithImpl<$Res, CaseDetail>;
  @useResult
  $Res call(
      {@JsonKey(name: 'case_id') String caseId,
      String findings,
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
      @JsonKey(name: 'image_urls') List<CaseImageUrl>? imageUrls});
}

/// @nodoc
class _$CaseDetailCopyWithImpl<$Res, $Val extends CaseDetail>
    implements $CaseDetailCopyWith<$Res> {
  _$CaseDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaseDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caseId = null,
    Object? findings = null,
    Object? referenceImpression = freezed,
    Object? generatedImpression = freezed,
    Object? editedImpression = freezed,
    Object? generatedAt = freezed,
    Object? editedAt = freezed,
    Object? baseImpression = freezed,
    Object? preferencesApplied = freezed,
    Object? baseImpressionModel = freezed,
    Object? refinementModel = freezed,
    Object? editHistory = freezed,
    Object? imageUrls = freezed,
  }) {
    return _then(_value.copyWith(
      caseId: null == caseId
          ? _value.caseId
          : caseId // ignore: cast_nullable_to_non_nullable
              as String,
      findings: null == findings
          ? _value.findings
          : findings // ignore: cast_nullable_to_non_nullable
              as String,
      referenceImpression: freezed == referenceImpression
          ? _value.referenceImpression
          : referenceImpression // ignore: cast_nullable_to_non_nullable
              as String?,
      generatedImpression: freezed == generatedImpression
          ? _value.generatedImpression
          : generatedImpression // ignore: cast_nullable_to_non_nullable
              as String?,
      editedImpression: freezed == editedImpression
          ? _value.editedImpression
          : editedImpression // ignore: cast_nullable_to_non_nullable
              as String?,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as double?,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as double?,
      baseImpression: freezed == baseImpression
          ? _value.baseImpression
          : baseImpression // ignore: cast_nullable_to_non_nullable
              as String?,
      preferencesApplied: freezed == preferencesApplied
          ? _value.preferencesApplied
          : preferencesApplied // ignore: cast_nullable_to_non_nullable
              as List<CaseAppliedPreference>?,
      baseImpressionModel: freezed == baseImpressionModel
          ? _value.baseImpressionModel
          : baseImpressionModel // ignore: cast_nullable_to_non_nullable
              as String?,
      refinementModel: freezed == refinementModel
          ? _value.refinementModel
          : refinementModel // ignore: cast_nullable_to_non_nullable
              as String?,
      editHistory: freezed == editHistory
          ? _value.editHistory
          : editHistory // ignore: cast_nullable_to_non_nullable
              as List<CaseEditHistoryEntry>?,
      imageUrls: freezed == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<CaseImageUrl>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CaseDetailImplCopyWith<$Res>
    implements $CaseDetailCopyWith<$Res> {
  factory _$$CaseDetailImplCopyWith(
          _$CaseDetailImpl value, $Res Function(_$CaseDetailImpl) then) =
      __$$CaseDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'case_id') String caseId,
      String findings,
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
      @JsonKey(name: 'image_urls') List<CaseImageUrl>? imageUrls});
}

/// @nodoc
class __$$CaseDetailImplCopyWithImpl<$Res>
    extends _$CaseDetailCopyWithImpl<$Res, _$CaseDetailImpl>
    implements _$$CaseDetailImplCopyWith<$Res> {
  __$$CaseDetailImplCopyWithImpl(
      _$CaseDetailImpl _value, $Res Function(_$CaseDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of CaseDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caseId = null,
    Object? findings = null,
    Object? referenceImpression = freezed,
    Object? generatedImpression = freezed,
    Object? editedImpression = freezed,
    Object? generatedAt = freezed,
    Object? editedAt = freezed,
    Object? baseImpression = freezed,
    Object? preferencesApplied = freezed,
    Object? baseImpressionModel = freezed,
    Object? refinementModel = freezed,
    Object? editHistory = freezed,
    Object? imageUrls = freezed,
  }) {
    return _then(_$CaseDetailImpl(
      caseId: null == caseId
          ? _value.caseId
          : caseId // ignore: cast_nullable_to_non_nullable
              as String,
      findings: null == findings
          ? _value.findings
          : findings // ignore: cast_nullable_to_non_nullable
              as String,
      referenceImpression: freezed == referenceImpression
          ? _value.referenceImpression
          : referenceImpression // ignore: cast_nullable_to_non_nullable
              as String?,
      generatedImpression: freezed == generatedImpression
          ? _value.generatedImpression
          : generatedImpression // ignore: cast_nullable_to_non_nullable
              as String?,
      editedImpression: freezed == editedImpression
          ? _value.editedImpression
          : editedImpression // ignore: cast_nullable_to_non_nullable
              as String?,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as double?,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as double?,
      baseImpression: freezed == baseImpression
          ? _value.baseImpression
          : baseImpression // ignore: cast_nullable_to_non_nullable
              as String?,
      preferencesApplied: freezed == preferencesApplied
          ? _value._preferencesApplied
          : preferencesApplied // ignore: cast_nullable_to_non_nullable
              as List<CaseAppliedPreference>?,
      baseImpressionModel: freezed == baseImpressionModel
          ? _value.baseImpressionModel
          : baseImpressionModel // ignore: cast_nullable_to_non_nullable
              as String?,
      refinementModel: freezed == refinementModel
          ? _value.refinementModel
          : refinementModel // ignore: cast_nullable_to_non_nullable
              as String?,
      editHistory: freezed == editHistory
          ? _value._editHistory
          : editHistory // ignore: cast_nullable_to_non_nullable
              as List<CaseEditHistoryEntry>?,
      imageUrls: freezed == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<CaseImageUrl>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CaseDetailImpl extends _CaseDetail {
  const _$CaseDetailImpl(
      {@JsonKey(name: 'case_id') this.caseId = '',
      this.findings = '',
      @JsonKey(name: 'reference_impression') this.referenceImpression,
      @JsonKey(name: 'generated_impression') this.generatedImpression,
      @JsonKey(name: 'edited_impression') this.editedImpression,
      @JsonKey(name: 'generated_at') this.generatedAt,
      @JsonKey(name: 'edited_at') this.editedAt,
      @JsonKey(name: 'base_impression') this.baseImpression,
      @JsonKey(name: 'preferences_applied')
      final List<CaseAppliedPreference>? preferencesApplied,
      @JsonKey(name: 'base_impression_model') this.baseImpressionModel,
      @JsonKey(name: 'refinement_model') this.refinementModel,
      @JsonKey(name: 'edit_history')
      final List<CaseEditHistoryEntry>? editHistory,
      @JsonKey(name: 'image_urls') final List<CaseImageUrl>? imageUrls})
      : _preferencesApplied = preferencesApplied,
        _editHistory = editHistory,
        _imageUrls = imageUrls,
        super._();

  factory _$CaseDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaseDetailImplFromJson(json);

  @override
  @JsonKey(name: 'case_id')
  final String caseId;
  @override
  @JsonKey()
  final String findings;
  @override
  @JsonKey(name: 'reference_impression')
  final String? referenceImpression;
  @override
  @JsonKey(name: 'generated_impression')
  final String? generatedImpression;
  @override
  @JsonKey(name: 'edited_impression')
  final String? editedImpression;
  @override
  @JsonKey(name: 'generated_at')
  final double? generatedAt;
  @override
  @JsonKey(name: 'edited_at')
  final double? editedAt;
  @override
  @JsonKey(name: 'base_impression')
  final String? baseImpression;
  final List<CaseAppliedPreference>? _preferencesApplied;
  @override
  @JsonKey(name: 'preferences_applied')
  List<CaseAppliedPreference>? get preferencesApplied {
    final value = _preferencesApplied;
    if (value == null) return null;
    if (_preferencesApplied is EqualUnmodifiableListView)
      return _preferencesApplied;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'base_impression_model')
  final String? baseImpressionModel;
  @override
  @JsonKey(name: 'refinement_model')
  final String? refinementModel;
  final List<CaseEditHistoryEntry>? _editHistory;
  @override
  @JsonKey(name: 'edit_history')
  List<CaseEditHistoryEntry>? get editHistory {
    final value = _editHistory;
    if (value == null) return null;
    if (_editHistory is EqualUnmodifiableListView) return _editHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<CaseImageUrl>? _imageUrls;
  @override
  @JsonKey(name: 'image_urls')
  List<CaseImageUrl>? get imageUrls {
    final value = _imageUrls;
    if (value == null) return null;
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CaseDetail(caseId: $caseId, findings: $findings, referenceImpression: $referenceImpression, generatedImpression: $generatedImpression, editedImpression: $editedImpression, generatedAt: $generatedAt, editedAt: $editedAt, baseImpression: $baseImpression, preferencesApplied: $preferencesApplied, baseImpressionModel: $baseImpressionModel, refinementModel: $refinementModel, editHistory: $editHistory, imageUrls: $imageUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaseDetailImpl &&
            (identical(other.caseId, caseId) || other.caseId == caseId) &&
            (identical(other.findings, findings) ||
                other.findings == findings) &&
            (identical(other.referenceImpression, referenceImpression) ||
                other.referenceImpression == referenceImpression) &&
            (identical(other.generatedImpression, generatedImpression) ||
                other.generatedImpression == generatedImpression) &&
            (identical(other.editedImpression, editedImpression) ||
                other.editedImpression == editedImpression) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.editedAt, editedAt) ||
                other.editedAt == editedAt) &&
            (identical(other.baseImpression, baseImpression) ||
                other.baseImpression == baseImpression) &&
            const DeepCollectionEquality()
                .equals(other._preferencesApplied, _preferencesApplied) &&
            (identical(other.baseImpressionModel, baseImpressionModel) ||
                other.baseImpressionModel == baseImpressionModel) &&
            (identical(other.refinementModel, refinementModel) ||
                other.refinementModel == refinementModel) &&
            const DeepCollectionEquality()
                .equals(other._editHistory, _editHistory) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      caseId,
      findings,
      referenceImpression,
      generatedImpression,
      editedImpression,
      generatedAt,
      editedAt,
      baseImpression,
      const DeepCollectionEquality().hash(_preferencesApplied),
      baseImpressionModel,
      refinementModel,
      const DeepCollectionEquality().hash(_editHistory),
      const DeepCollectionEquality().hash(_imageUrls));

  /// Create a copy of CaseDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaseDetailImplCopyWith<_$CaseDetailImpl> get copyWith =>
      __$$CaseDetailImplCopyWithImpl<_$CaseDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CaseDetailImplToJson(
      this,
    );
  }
}

abstract class _CaseDetail extends CaseDetail {
  const factory _CaseDetail(
      {@JsonKey(name: 'case_id') final String caseId,
      final String findings,
      @JsonKey(name: 'reference_impression') final String? referenceImpression,
      @JsonKey(name: 'generated_impression') final String? generatedImpression,
      @JsonKey(name: 'edited_impression') final String? editedImpression,
      @JsonKey(name: 'generated_at') final double? generatedAt,
      @JsonKey(name: 'edited_at') final double? editedAt,
      @JsonKey(name: 'base_impression') final String? baseImpression,
      @JsonKey(name: 'preferences_applied')
      final List<CaseAppliedPreference>? preferencesApplied,
      @JsonKey(name: 'base_impression_model') final String? baseImpressionModel,
      @JsonKey(name: 'refinement_model') final String? refinementModel,
      @JsonKey(name: 'edit_history')
      final List<CaseEditHistoryEntry>? editHistory,
      @JsonKey(name: 'image_urls')
      final List<CaseImageUrl>? imageUrls}) = _$CaseDetailImpl;
  const _CaseDetail._() : super._();

  factory _CaseDetail.fromJson(Map<String, dynamic> json) =
      _$CaseDetailImpl.fromJson;

  @override
  @JsonKey(name: 'case_id')
  String get caseId;
  @override
  String get findings;
  @override
  @JsonKey(name: 'reference_impression')
  String? get referenceImpression;
  @override
  @JsonKey(name: 'generated_impression')
  String? get generatedImpression;
  @override
  @JsonKey(name: 'edited_impression')
  String? get editedImpression;
  @override
  @JsonKey(name: 'generated_at')
  double? get generatedAt;
  @override
  @JsonKey(name: 'edited_at')
  double? get editedAt;
  @override
  @JsonKey(name: 'base_impression')
  String? get baseImpression;
  @override
  @JsonKey(name: 'preferences_applied')
  List<CaseAppliedPreference>? get preferencesApplied;
  @override
  @JsonKey(name: 'base_impression_model')
  String? get baseImpressionModel;
  @override
  @JsonKey(name: 'refinement_model')
  String? get refinementModel;
  @override
  @JsonKey(name: 'edit_history')
  List<CaseEditHistoryEntry>? get editHistory;
  @override
  @JsonKey(name: 'image_urls')
  List<CaseImageUrl>? get imageUrls;

  /// Create a copy of CaseDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaseDetailImplCopyWith<_$CaseDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
