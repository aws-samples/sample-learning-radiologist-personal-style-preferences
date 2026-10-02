// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GenerateRequest _$GenerateRequestFromJson(Map<String, dynamic> json) {
  return _GenerateRequest.fromJson(json);
}

/// @nodoc
mixin _$GenerateRequest {
  @JsonKey(name: 'case_id')
  String get caseId => throw _privateConstructorUsedError;
  String get findings => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinical_interpretation')
  bool get clinicalInterpretation => throw _privateConstructorUsedError;
  @JsonKey(name: 'idempotency_key')
  String get idempotencyKey => throw _privateConstructorUsedError;

  /// Serializes this GenerateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GenerateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GenerateRequestCopyWith<GenerateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenerateRequestCopyWith<$Res> {
  factory $GenerateRequestCopyWith(
          GenerateRequest value, $Res Function(GenerateRequest) then) =
      _$GenerateRequestCopyWithImpl<$Res, GenerateRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'case_id') String caseId,
      String findings,
      @JsonKey(name: 'clinical_interpretation') bool clinicalInterpretation,
      @JsonKey(name: 'idempotency_key') String idempotencyKey});
}

/// @nodoc
class _$GenerateRequestCopyWithImpl<$Res, $Val extends GenerateRequest>
    implements $GenerateRequestCopyWith<$Res> {
  _$GenerateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GenerateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caseId = null,
    Object? findings = null,
    Object? clinicalInterpretation = null,
    Object? idempotencyKey = null,
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
      clinicalInterpretation: null == clinicalInterpretation
          ? _value.clinicalInterpretation
          : clinicalInterpretation // ignore: cast_nullable_to_non_nullable
              as bool,
      idempotencyKey: null == idempotencyKey
          ? _value.idempotencyKey
          : idempotencyKey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GenerateRequestImplCopyWith<$Res>
    implements $GenerateRequestCopyWith<$Res> {
  factory _$$GenerateRequestImplCopyWith(_$GenerateRequestImpl value,
          $Res Function(_$GenerateRequestImpl) then) =
      __$$GenerateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'case_id') String caseId,
      String findings,
      @JsonKey(name: 'clinical_interpretation') bool clinicalInterpretation,
      @JsonKey(name: 'idempotency_key') String idempotencyKey});
}

/// @nodoc
class __$$GenerateRequestImplCopyWithImpl<$Res>
    extends _$GenerateRequestCopyWithImpl<$Res, _$GenerateRequestImpl>
    implements _$$GenerateRequestImplCopyWith<$Res> {
  __$$GenerateRequestImplCopyWithImpl(
      _$GenerateRequestImpl _value, $Res Function(_$GenerateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of GenerateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caseId = null,
    Object? findings = null,
    Object? clinicalInterpretation = null,
    Object? idempotencyKey = null,
  }) {
    return _then(_$GenerateRequestImpl(
      caseId: null == caseId
          ? _value.caseId
          : caseId // ignore: cast_nullable_to_non_nullable
              as String,
      findings: null == findings
          ? _value.findings
          : findings // ignore: cast_nullable_to_non_nullable
              as String,
      clinicalInterpretation: null == clinicalInterpretation
          ? _value.clinicalInterpretation
          : clinicalInterpretation // ignore: cast_nullable_to_non_nullable
              as bool,
      idempotencyKey: null == idempotencyKey
          ? _value.idempotencyKey
          : idempotencyKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GenerateRequestImpl implements _GenerateRequest {
  const _$GenerateRequestImpl(
      {@JsonKey(name: 'case_id') required this.caseId,
      required this.findings,
      @JsonKey(name: 'clinical_interpretation')
      this.clinicalInterpretation = false,
      @JsonKey(name: 'idempotency_key') required this.idempotencyKey});

  factory _$GenerateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$GenerateRequestImplFromJson(json);

  @override
  @JsonKey(name: 'case_id')
  final String caseId;
  @override
  final String findings;
  @override
  @JsonKey(name: 'clinical_interpretation')
  final bool clinicalInterpretation;
  @override
  @JsonKey(name: 'idempotency_key')
  final String idempotencyKey;

  @override
  String toString() {
    return 'GenerateRequest(caseId: $caseId, findings: $findings, clinicalInterpretation: $clinicalInterpretation, idempotencyKey: $idempotencyKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenerateRequestImpl &&
            (identical(other.caseId, caseId) || other.caseId == caseId) &&
            (identical(other.findings, findings) ||
                other.findings == findings) &&
            (identical(other.clinicalInterpretation, clinicalInterpretation) ||
                other.clinicalInterpretation == clinicalInterpretation) &&
            (identical(other.idempotencyKey, idempotencyKey) ||
                other.idempotencyKey == idempotencyKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, caseId, findings, clinicalInterpretation, idempotencyKey);

  /// Create a copy of GenerateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenerateRequestImplCopyWith<_$GenerateRequestImpl> get copyWith =>
      __$$GenerateRequestImplCopyWithImpl<_$GenerateRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GenerateRequestImplToJson(
      this,
    );
  }
}

abstract class _GenerateRequest implements GenerateRequest {
  const factory _GenerateRequest(
      {@JsonKey(name: 'case_id') required final String caseId,
      required final String findings,
      @JsonKey(name: 'clinical_interpretation')
      final bool clinicalInterpretation,
      @JsonKey(name: 'idempotency_key')
      required final String idempotencyKey}) = _$GenerateRequestImpl;

  factory _GenerateRequest.fromJson(Map<String, dynamic> json) =
      _$GenerateRequestImpl.fromJson;

  @override
  @JsonKey(name: 'case_id')
  String get caseId;
  @override
  String get findings;
  @override
  @JsonKey(name: 'clinical_interpretation')
  bool get clinicalInterpretation;
  @override
  @JsonKey(name: 'idempotency_key')
  String get idempotencyKey;

  /// Create a copy of GenerateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenerateRequestImplCopyWith<_$GenerateRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppliedPreference _$AppliedPreferenceFromJson(Map<String, dynamic> json) {
  return _AppliedPreference.fromJson(json);
}

/// @nodoc
mixin _$AppliedPreference {
  @JsonKey(name: 'preference_id')
  String get preferenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'preference_text')
  String get preferenceText => throw _privateConstructorUsedError;

  /// Serializes this AppliedPreference to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppliedPreference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppliedPreferenceCopyWith<AppliedPreference> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppliedPreferenceCopyWith<$Res> {
  factory $AppliedPreferenceCopyWith(
          AppliedPreference value, $Res Function(AppliedPreference) then) =
      _$AppliedPreferenceCopyWithImpl<$Res, AppliedPreference>;
  @useResult
  $Res call(
      {@JsonKey(name: 'preference_id') String preferenceId,
      @JsonKey(name: 'preference_text') String preferenceText});
}

/// @nodoc
class _$AppliedPreferenceCopyWithImpl<$Res, $Val extends AppliedPreference>
    implements $AppliedPreferenceCopyWith<$Res> {
  _$AppliedPreferenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppliedPreference
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
abstract class _$$AppliedPreferenceImplCopyWith<$Res>
    implements $AppliedPreferenceCopyWith<$Res> {
  factory _$$AppliedPreferenceImplCopyWith(_$AppliedPreferenceImpl value,
          $Res Function(_$AppliedPreferenceImpl) then) =
      __$$AppliedPreferenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'preference_id') String preferenceId,
      @JsonKey(name: 'preference_text') String preferenceText});
}

/// @nodoc
class __$$AppliedPreferenceImplCopyWithImpl<$Res>
    extends _$AppliedPreferenceCopyWithImpl<$Res, _$AppliedPreferenceImpl>
    implements _$$AppliedPreferenceImplCopyWith<$Res> {
  __$$AppliedPreferenceImplCopyWithImpl(_$AppliedPreferenceImpl _value,
      $Res Function(_$AppliedPreferenceImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppliedPreference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferenceId = null,
    Object? preferenceText = null,
  }) {
    return _then(_$AppliedPreferenceImpl(
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
class _$AppliedPreferenceImpl implements _AppliedPreference {
  const _$AppliedPreferenceImpl(
      {@JsonKey(name: 'preference_id') this.preferenceId = '',
      @JsonKey(name: 'preference_text') this.preferenceText = ''});

  factory _$AppliedPreferenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppliedPreferenceImplFromJson(json);

  @override
  @JsonKey(name: 'preference_id')
  final String preferenceId;
  @override
  @JsonKey(name: 'preference_text')
  final String preferenceText;

  @override
  String toString() {
    return 'AppliedPreference(preferenceId: $preferenceId, preferenceText: $preferenceText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppliedPreferenceImpl &&
            (identical(other.preferenceId, preferenceId) ||
                other.preferenceId == preferenceId) &&
            (identical(other.preferenceText, preferenceText) ||
                other.preferenceText == preferenceText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, preferenceId, preferenceText);

  /// Create a copy of AppliedPreference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppliedPreferenceImplCopyWith<_$AppliedPreferenceImpl> get copyWith =>
      __$$AppliedPreferenceImplCopyWithImpl<_$AppliedPreferenceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppliedPreferenceImplToJson(
      this,
    );
  }
}

abstract class _AppliedPreference implements AppliedPreference {
  const factory _AppliedPreference(
          {@JsonKey(name: 'preference_id') final String preferenceId,
          @JsonKey(name: 'preference_text') final String preferenceText}) =
      _$AppliedPreferenceImpl;

  factory _AppliedPreference.fromJson(Map<String, dynamic> json) =
      _$AppliedPreferenceImpl.fromJson;

  @override
  @JsonKey(name: 'preference_id')
  String get preferenceId;
  @override
  @JsonKey(name: 'preference_text')
  String get preferenceText;

  /// Create a copy of AppliedPreference
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppliedPreferenceImplCopyWith<_$AppliedPreferenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RetrievedPreferenceTrace _$RetrievedPreferenceTraceFromJson(
    Map<String, dynamic> json) {
  return _RetrievedPreferenceTrace.fromJson(json);
}

/// @nodoc
mixin _$RetrievedPreferenceTrace {
  @JsonKey(name: 'preference_id')
  String get preferenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'preference_text')
  String get preferenceText => throw _privateConstructorUsedError;
  @JsonKey(name: 'similarity_score')
  double get similarityScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_case_id')
  String? get sourceCaseId => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;

  /// Serializes this RetrievedPreferenceTrace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RetrievedPreferenceTrace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RetrievedPreferenceTraceCopyWith<RetrievedPreferenceTrace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RetrievedPreferenceTraceCopyWith<$Res> {
  factory $RetrievedPreferenceTraceCopyWith(RetrievedPreferenceTrace value,
          $Res Function(RetrievedPreferenceTrace) then) =
      _$RetrievedPreferenceTraceCopyWithImpl<$Res, RetrievedPreferenceTrace>;
  @useResult
  $Res call(
      {@JsonKey(name: 'preference_id') String preferenceId,
      @JsonKey(name: 'preference_text') String preferenceText,
      @JsonKey(name: 'similarity_score') double similarityScore,
      @JsonKey(name: 'source_case_id') String? sourceCaseId,
      String? category});
}

/// @nodoc
class _$RetrievedPreferenceTraceCopyWithImpl<$Res,
        $Val extends RetrievedPreferenceTrace>
    implements $RetrievedPreferenceTraceCopyWith<$Res> {
  _$RetrievedPreferenceTraceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RetrievedPreferenceTrace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferenceId = null,
    Object? preferenceText = null,
    Object? similarityScore = null,
    Object? sourceCaseId = freezed,
    Object? category = freezed,
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
      similarityScore: null == similarityScore
          ? _value.similarityScore
          : similarityScore // ignore: cast_nullable_to_non_nullable
              as double,
      sourceCaseId: freezed == sourceCaseId
          ? _value.sourceCaseId
          : sourceCaseId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RetrievedPreferenceTraceImplCopyWith<$Res>
    implements $RetrievedPreferenceTraceCopyWith<$Res> {
  factory _$$RetrievedPreferenceTraceImplCopyWith(
          _$RetrievedPreferenceTraceImpl value,
          $Res Function(_$RetrievedPreferenceTraceImpl) then) =
      __$$RetrievedPreferenceTraceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'preference_id') String preferenceId,
      @JsonKey(name: 'preference_text') String preferenceText,
      @JsonKey(name: 'similarity_score') double similarityScore,
      @JsonKey(name: 'source_case_id') String? sourceCaseId,
      String? category});
}

/// @nodoc
class __$$RetrievedPreferenceTraceImplCopyWithImpl<$Res>
    extends _$RetrievedPreferenceTraceCopyWithImpl<$Res,
        _$RetrievedPreferenceTraceImpl>
    implements _$$RetrievedPreferenceTraceImplCopyWith<$Res> {
  __$$RetrievedPreferenceTraceImplCopyWithImpl(
      _$RetrievedPreferenceTraceImpl _value,
      $Res Function(_$RetrievedPreferenceTraceImpl) _then)
      : super(_value, _then);

  /// Create a copy of RetrievedPreferenceTrace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferenceId = null,
    Object? preferenceText = null,
    Object? similarityScore = null,
    Object? sourceCaseId = freezed,
    Object? category = freezed,
  }) {
    return _then(_$RetrievedPreferenceTraceImpl(
      preferenceId: null == preferenceId
          ? _value.preferenceId
          : preferenceId // ignore: cast_nullable_to_non_nullable
              as String,
      preferenceText: null == preferenceText
          ? _value.preferenceText
          : preferenceText // ignore: cast_nullable_to_non_nullable
              as String,
      similarityScore: null == similarityScore
          ? _value.similarityScore
          : similarityScore // ignore: cast_nullable_to_non_nullable
              as double,
      sourceCaseId: freezed == sourceCaseId
          ? _value.sourceCaseId
          : sourceCaseId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RetrievedPreferenceTraceImpl implements _RetrievedPreferenceTrace {
  const _$RetrievedPreferenceTraceImpl(
      {@JsonKey(name: 'preference_id') this.preferenceId = '',
      @JsonKey(name: 'preference_text') this.preferenceText = '',
      @JsonKey(name: 'similarity_score') this.similarityScore = 0.0,
      @JsonKey(name: 'source_case_id') this.sourceCaseId,
      this.category});

  factory _$RetrievedPreferenceTraceImpl.fromJson(Map<String, dynamic> json) =>
      _$$RetrievedPreferenceTraceImplFromJson(json);

  @override
  @JsonKey(name: 'preference_id')
  final String preferenceId;
  @override
  @JsonKey(name: 'preference_text')
  final String preferenceText;
  @override
  @JsonKey(name: 'similarity_score')
  final double similarityScore;
  @override
  @JsonKey(name: 'source_case_id')
  final String? sourceCaseId;
  @override
  final String? category;

  @override
  String toString() {
    return 'RetrievedPreferenceTrace(preferenceId: $preferenceId, preferenceText: $preferenceText, similarityScore: $similarityScore, sourceCaseId: $sourceCaseId, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RetrievedPreferenceTraceImpl &&
            (identical(other.preferenceId, preferenceId) ||
                other.preferenceId == preferenceId) &&
            (identical(other.preferenceText, preferenceText) ||
                other.preferenceText == preferenceText) &&
            (identical(other.similarityScore, similarityScore) ||
                other.similarityScore == similarityScore) &&
            (identical(other.sourceCaseId, sourceCaseId) ||
                other.sourceCaseId == sourceCaseId) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, preferenceId, preferenceText,
      similarityScore, sourceCaseId, category);

  /// Create a copy of RetrievedPreferenceTrace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RetrievedPreferenceTraceImplCopyWith<_$RetrievedPreferenceTraceImpl>
      get copyWith => __$$RetrievedPreferenceTraceImplCopyWithImpl<
          _$RetrievedPreferenceTraceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RetrievedPreferenceTraceImplToJson(
      this,
    );
  }
}

abstract class _RetrievedPreferenceTrace implements RetrievedPreferenceTrace {
  const factory _RetrievedPreferenceTrace(
      {@JsonKey(name: 'preference_id') final String preferenceId,
      @JsonKey(name: 'preference_text') final String preferenceText,
      @JsonKey(name: 'similarity_score') final double similarityScore,
      @JsonKey(name: 'source_case_id') final String? sourceCaseId,
      final String? category}) = _$RetrievedPreferenceTraceImpl;

  factory _RetrievedPreferenceTrace.fromJson(Map<String, dynamic> json) =
      _$RetrievedPreferenceTraceImpl.fromJson;

  @override
  @JsonKey(name: 'preference_id')
  String get preferenceId;
  @override
  @JsonKey(name: 'preference_text')
  String get preferenceText;
  @override
  @JsonKey(name: 'similarity_score')
  double get similarityScore;
  @override
  @JsonKey(name: 'source_case_id')
  String? get sourceCaseId;
  @override
  String? get category;

  /// Create a copy of RetrievedPreferenceTrace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RetrievedPreferenceTraceImplCopyWith<_$RetrievedPreferenceTraceImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RetrievalTrace _$RetrievalTraceFromJson(Map<String, dynamic> json) {
  return _RetrievalTrace.fromJson(json);
}

/// @nodoc
mixin _$RetrievalTrace {
  @JsonKey(name: 'total_preferences')
  int get totalPreferences => throw _privateConstructorUsedError;
  @JsonKey(name: 'k_requested')
  int get kRequested => throw _privateConstructorUsedError;
  @JsonKey(name: 'k_returned')
  int get kReturned => throw _privateConstructorUsedError;
  List<RetrievedPreferenceTrace> get retrieved =>
      throw _privateConstructorUsedError;

  /// Serializes this RetrievalTrace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RetrievalTrace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RetrievalTraceCopyWith<RetrievalTrace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RetrievalTraceCopyWith<$Res> {
  factory $RetrievalTraceCopyWith(
          RetrievalTrace value, $Res Function(RetrievalTrace) then) =
      _$RetrievalTraceCopyWithImpl<$Res, RetrievalTrace>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_preferences') int totalPreferences,
      @JsonKey(name: 'k_requested') int kRequested,
      @JsonKey(name: 'k_returned') int kReturned,
      List<RetrievedPreferenceTrace> retrieved});
}

/// @nodoc
class _$RetrievalTraceCopyWithImpl<$Res, $Val extends RetrievalTrace>
    implements $RetrievalTraceCopyWith<$Res> {
  _$RetrievalTraceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RetrievalTrace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPreferences = null,
    Object? kRequested = null,
    Object? kReturned = null,
    Object? retrieved = null,
  }) {
    return _then(_value.copyWith(
      totalPreferences: null == totalPreferences
          ? _value.totalPreferences
          : totalPreferences // ignore: cast_nullable_to_non_nullable
              as int,
      kRequested: null == kRequested
          ? _value.kRequested
          : kRequested // ignore: cast_nullable_to_non_nullable
              as int,
      kReturned: null == kReturned
          ? _value.kReturned
          : kReturned // ignore: cast_nullable_to_non_nullable
              as int,
      retrieved: null == retrieved
          ? _value.retrieved
          : retrieved // ignore: cast_nullable_to_non_nullable
              as List<RetrievedPreferenceTrace>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RetrievalTraceImplCopyWith<$Res>
    implements $RetrievalTraceCopyWith<$Res> {
  factory _$$RetrievalTraceImplCopyWith(_$RetrievalTraceImpl value,
          $Res Function(_$RetrievalTraceImpl) then) =
      __$$RetrievalTraceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_preferences') int totalPreferences,
      @JsonKey(name: 'k_requested') int kRequested,
      @JsonKey(name: 'k_returned') int kReturned,
      List<RetrievedPreferenceTrace> retrieved});
}

/// @nodoc
class __$$RetrievalTraceImplCopyWithImpl<$Res>
    extends _$RetrievalTraceCopyWithImpl<$Res, _$RetrievalTraceImpl>
    implements _$$RetrievalTraceImplCopyWith<$Res> {
  __$$RetrievalTraceImplCopyWithImpl(
      _$RetrievalTraceImpl _value, $Res Function(_$RetrievalTraceImpl) _then)
      : super(_value, _then);

  /// Create a copy of RetrievalTrace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPreferences = null,
    Object? kRequested = null,
    Object? kReturned = null,
    Object? retrieved = null,
  }) {
    return _then(_$RetrievalTraceImpl(
      totalPreferences: null == totalPreferences
          ? _value.totalPreferences
          : totalPreferences // ignore: cast_nullable_to_non_nullable
              as int,
      kRequested: null == kRequested
          ? _value.kRequested
          : kRequested // ignore: cast_nullable_to_non_nullable
              as int,
      kReturned: null == kReturned
          ? _value.kReturned
          : kReturned // ignore: cast_nullable_to_non_nullable
              as int,
      retrieved: null == retrieved
          ? _value._retrieved
          : retrieved // ignore: cast_nullable_to_non_nullable
              as List<RetrievedPreferenceTrace>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RetrievalTraceImpl implements _RetrievalTrace {
  const _$RetrievalTraceImpl(
      {@JsonKey(name: 'total_preferences') this.totalPreferences = 0,
      @JsonKey(name: 'k_requested') this.kRequested = 0,
      @JsonKey(name: 'k_returned') this.kReturned = 0,
      final List<RetrievedPreferenceTrace> retrieved = const []})
      : _retrieved = retrieved;

  factory _$RetrievalTraceImpl.fromJson(Map<String, dynamic> json) =>
      _$$RetrievalTraceImplFromJson(json);

  @override
  @JsonKey(name: 'total_preferences')
  final int totalPreferences;
  @override
  @JsonKey(name: 'k_requested')
  final int kRequested;
  @override
  @JsonKey(name: 'k_returned')
  final int kReturned;
  final List<RetrievedPreferenceTrace> _retrieved;
  @override
  @JsonKey()
  List<RetrievedPreferenceTrace> get retrieved {
    if (_retrieved is EqualUnmodifiableListView) return _retrieved;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_retrieved);
  }

  @override
  String toString() {
    return 'RetrievalTrace(totalPreferences: $totalPreferences, kRequested: $kRequested, kReturned: $kReturned, retrieved: $retrieved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RetrievalTraceImpl &&
            (identical(other.totalPreferences, totalPreferences) ||
                other.totalPreferences == totalPreferences) &&
            (identical(other.kRequested, kRequested) ||
                other.kRequested == kRequested) &&
            (identical(other.kReturned, kReturned) ||
                other.kReturned == kReturned) &&
            const DeepCollectionEquality()
                .equals(other._retrieved, _retrieved));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalPreferences, kRequested,
      kReturned, const DeepCollectionEquality().hash(_retrieved));

  /// Create a copy of RetrievalTrace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RetrievalTraceImplCopyWith<_$RetrievalTraceImpl> get copyWith =>
      __$$RetrievalTraceImplCopyWithImpl<_$RetrievalTraceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RetrievalTraceImplToJson(
      this,
    );
  }
}

abstract class _RetrievalTrace implements RetrievalTrace {
  const factory _RetrievalTrace(
      {@JsonKey(name: 'total_preferences') final int totalPreferences,
      @JsonKey(name: 'k_requested') final int kRequested,
      @JsonKey(name: 'k_returned') final int kReturned,
      final List<RetrievedPreferenceTrace> retrieved}) = _$RetrievalTraceImpl;

  factory _RetrievalTrace.fromJson(Map<String, dynamic> json) =
      _$RetrievalTraceImpl.fromJson;

  @override
  @JsonKey(name: 'total_preferences')
  int get totalPreferences;
  @override
  @JsonKey(name: 'k_requested')
  int get kRequested;
  @override
  @JsonKey(name: 'k_returned')
  int get kReturned;
  @override
  List<RetrievedPreferenceTrace> get retrieved;

  /// Create a copy of RetrievalTrace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RetrievalTraceImplCopyWith<_$RetrievalTraceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RefinementTrace _$RefinementTraceFromJson(Map<String, dynamic> json) {
  return _RefinementTrace.fromJson(json);
}

/// @nodoc
mixin _$RefinementTrace {
  @JsonKey(name: 'was_applied')
  bool get wasApplied => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_length')
  int get baseLength => throw _privateConstructorUsedError;
  @JsonKey(name: 'refined_length')
  int get refinedLength => throw _privateConstructorUsedError;
  @JsonKey(name: 'edit_distance')
  double get editDistance => throw _privateConstructorUsedError;
  @JsonKey(name: 'model_id')
  String? get modelId => throw _privateConstructorUsedError;

  /// Serializes this RefinementTrace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefinementTrace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefinementTraceCopyWith<RefinementTrace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefinementTraceCopyWith<$Res> {
  factory $RefinementTraceCopyWith(
          RefinementTrace value, $Res Function(RefinementTrace) then) =
      _$RefinementTraceCopyWithImpl<$Res, RefinementTrace>;
  @useResult
  $Res call(
      {@JsonKey(name: 'was_applied') bool wasApplied,
      @JsonKey(name: 'base_length') int baseLength,
      @JsonKey(name: 'refined_length') int refinedLength,
      @JsonKey(name: 'edit_distance') double editDistance,
      @JsonKey(name: 'model_id') String? modelId});
}

/// @nodoc
class _$RefinementTraceCopyWithImpl<$Res, $Val extends RefinementTrace>
    implements $RefinementTraceCopyWith<$Res> {
  _$RefinementTraceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefinementTrace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wasApplied = null,
    Object? baseLength = null,
    Object? refinedLength = null,
    Object? editDistance = null,
    Object? modelId = freezed,
  }) {
    return _then(_value.copyWith(
      wasApplied: null == wasApplied
          ? _value.wasApplied
          : wasApplied // ignore: cast_nullable_to_non_nullable
              as bool,
      baseLength: null == baseLength
          ? _value.baseLength
          : baseLength // ignore: cast_nullable_to_non_nullable
              as int,
      refinedLength: null == refinedLength
          ? _value.refinedLength
          : refinedLength // ignore: cast_nullable_to_non_nullable
              as int,
      editDistance: null == editDistance
          ? _value.editDistance
          : editDistance // ignore: cast_nullable_to_non_nullable
              as double,
      modelId: freezed == modelId
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefinementTraceImplCopyWith<$Res>
    implements $RefinementTraceCopyWith<$Res> {
  factory _$$RefinementTraceImplCopyWith(_$RefinementTraceImpl value,
          $Res Function(_$RefinementTraceImpl) then) =
      __$$RefinementTraceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'was_applied') bool wasApplied,
      @JsonKey(name: 'base_length') int baseLength,
      @JsonKey(name: 'refined_length') int refinedLength,
      @JsonKey(name: 'edit_distance') double editDistance,
      @JsonKey(name: 'model_id') String? modelId});
}

/// @nodoc
class __$$RefinementTraceImplCopyWithImpl<$Res>
    extends _$RefinementTraceCopyWithImpl<$Res, _$RefinementTraceImpl>
    implements _$$RefinementTraceImplCopyWith<$Res> {
  __$$RefinementTraceImplCopyWithImpl(
      _$RefinementTraceImpl _value, $Res Function(_$RefinementTraceImpl) _then)
      : super(_value, _then);

  /// Create a copy of RefinementTrace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wasApplied = null,
    Object? baseLength = null,
    Object? refinedLength = null,
    Object? editDistance = null,
    Object? modelId = freezed,
  }) {
    return _then(_$RefinementTraceImpl(
      wasApplied: null == wasApplied
          ? _value.wasApplied
          : wasApplied // ignore: cast_nullable_to_non_nullable
              as bool,
      baseLength: null == baseLength
          ? _value.baseLength
          : baseLength // ignore: cast_nullable_to_non_nullable
              as int,
      refinedLength: null == refinedLength
          ? _value.refinedLength
          : refinedLength // ignore: cast_nullable_to_non_nullable
              as int,
      editDistance: null == editDistance
          ? _value.editDistance
          : editDistance // ignore: cast_nullable_to_non_nullable
              as double,
      modelId: freezed == modelId
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefinementTraceImpl implements _RefinementTrace {
  const _$RefinementTraceImpl(
      {@JsonKey(name: 'was_applied') this.wasApplied = false,
      @JsonKey(name: 'base_length') this.baseLength = 0,
      @JsonKey(name: 'refined_length') this.refinedLength = 0,
      @JsonKey(name: 'edit_distance') this.editDistance = 0.0,
      @JsonKey(name: 'model_id') this.modelId});

  factory _$RefinementTraceImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefinementTraceImplFromJson(json);

  @override
  @JsonKey(name: 'was_applied')
  final bool wasApplied;
  @override
  @JsonKey(name: 'base_length')
  final int baseLength;
  @override
  @JsonKey(name: 'refined_length')
  final int refinedLength;
  @override
  @JsonKey(name: 'edit_distance')
  final double editDistance;
  @override
  @JsonKey(name: 'model_id')
  final String? modelId;

  @override
  String toString() {
    return 'RefinementTrace(wasApplied: $wasApplied, baseLength: $baseLength, refinedLength: $refinedLength, editDistance: $editDistance, modelId: $modelId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefinementTraceImpl &&
            (identical(other.wasApplied, wasApplied) ||
                other.wasApplied == wasApplied) &&
            (identical(other.baseLength, baseLength) ||
                other.baseLength == baseLength) &&
            (identical(other.refinedLength, refinedLength) ||
                other.refinedLength == refinedLength) &&
            (identical(other.editDistance, editDistance) ||
                other.editDistance == editDistance) &&
            (identical(other.modelId, modelId) || other.modelId == modelId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, wasApplied, baseLength,
      refinedLength, editDistance, modelId);

  /// Create a copy of RefinementTrace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefinementTraceImplCopyWith<_$RefinementTraceImpl> get copyWith =>
      __$$RefinementTraceImplCopyWithImpl<_$RefinementTraceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefinementTraceImplToJson(
      this,
    );
  }
}

abstract class _RefinementTrace implements RefinementTrace {
  const factory _RefinementTrace(
          {@JsonKey(name: 'was_applied') final bool wasApplied,
          @JsonKey(name: 'base_length') final int baseLength,
          @JsonKey(name: 'refined_length') final int refinedLength,
          @JsonKey(name: 'edit_distance') final double editDistance,
          @JsonKey(name: 'model_id') final String? modelId}) =
      _$RefinementTraceImpl;

  factory _RefinementTrace.fromJson(Map<String, dynamic> json) =
      _$RefinementTraceImpl.fromJson;

  @override
  @JsonKey(name: 'was_applied')
  bool get wasApplied;
  @override
  @JsonKey(name: 'base_length')
  int get baseLength;
  @override
  @JsonKey(name: 'refined_length')
  int get refinedLength;
  @override
  @JsonKey(name: 'edit_distance')
  double get editDistance;
  @override
  @JsonKey(name: 'model_id')
  String? get modelId;

  /// Create a copy of RefinementTrace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefinementTraceImplCopyWith<_$RefinementTraceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GenerationTrace _$GenerationTraceFromJson(Map<String, dynamic> json) {
  return _GenerationTrace.fromJson(json);
}

/// @nodoc
mixin _$GenerationTrace {
  RetrievalTrace? get retrieval => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_generation_model')
  String? get baseGenerationModel => throw _privateConstructorUsedError;
  RefinementTrace? get refinement => throw _privateConstructorUsedError;

  /// Serializes this GenerationTrace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GenerationTrace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GenerationTraceCopyWith<GenerationTrace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenerationTraceCopyWith<$Res> {
  factory $GenerationTraceCopyWith(
          GenerationTrace value, $Res Function(GenerationTrace) then) =
      _$GenerationTraceCopyWithImpl<$Res, GenerationTrace>;
  @useResult
  $Res call(
      {RetrievalTrace? retrieval,
      @JsonKey(name: 'base_generation_model') String? baseGenerationModel,
      RefinementTrace? refinement});

  $RetrievalTraceCopyWith<$Res>? get retrieval;
  $RefinementTraceCopyWith<$Res>? get refinement;
}

/// @nodoc
class _$GenerationTraceCopyWithImpl<$Res, $Val extends GenerationTrace>
    implements $GenerationTraceCopyWith<$Res> {
  _$GenerationTraceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GenerationTrace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? retrieval = freezed,
    Object? baseGenerationModel = freezed,
    Object? refinement = freezed,
  }) {
    return _then(_value.copyWith(
      retrieval: freezed == retrieval
          ? _value.retrieval
          : retrieval // ignore: cast_nullable_to_non_nullable
              as RetrievalTrace?,
      baseGenerationModel: freezed == baseGenerationModel
          ? _value.baseGenerationModel
          : baseGenerationModel // ignore: cast_nullable_to_non_nullable
              as String?,
      refinement: freezed == refinement
          ? _value.refinement
          : refinement // ignore: cast_nullable_to_non_nullable
              as RefinementTrace?,
    ) as $Val);
  }

  /// Create a copy of GenerationTrace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RetrievalTraceCopyWith<$Res>? get retrieval {
    if (_value.retrieval == null) {
      return null;
    }

    return $RetrievalTraceCopyWith<$Res>(_value.retrieval!, (value) {
      return _then(_value.copyWith(retrieval: value) as $Val);
    });
  }

  /// Create a copy of GenerationTrace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RefinementTraceCopyWith<$Res>? get refinement {
    if (_value.refinement == null) {
      return null;
    }

    return $RefinementTraceCopyWith<$Res>(_value.refinement!, (value) {
      return _then(_value.copyWith(refinement: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GenerationTraceImplCopyWith<$Res>
    implements $GenerationTraceCopyWith<$Res> {
  factory _$$GenerationTraceImplCopyWith(_$GenerationTraceImpl value,
          $Res Function(_$GenerationTraceImpl) then) =
      __$$GenerationTraceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RetrievalTrace? retrieval,
      @JsonKey(name: 'base_generation_model') String? baseGenerationModel,
      RefinementTrace? refinement});

  @override
  $RetrievalTraceCopyWith<$Res>? get retrieval;
  @override
  $RefinementTraceCopyWith<$Res>? get refinement;
}

/// @nodoc
class __$$GenerationTraceImplCopyWithImpl<$Res>
    extends _$GenerationTraceCopyWithImpl<$Res, _$GenerationTraceImpl>
    implements _$$GenerationTraceImplCopyWith<$Res> {
  __$$GenerationTraceImplCopyWithImpl(
      _$GenerationTraceImpl _value, $Res Function(_$GenerationTraceImpl) _then)
      : super(_value, _then);

  /// Create a copy of GenerationTrace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? retrieval = freezed,
    Object? baseGenerationModel = freezed,
    Object? refinement = freezed,
  }) {
    return _then(_$GenerationTraceImpl(
      retrieval: freezed == retrieval
          ? _value.retrieval
          : retrieval // ignore: cast_nullable_to_non_nullable
              as RetrievalTrace?,
      baseGenerationModel: freezed == baseGenerationModel
          ? _value.baseGenerationModel
          : baseGenerationModel // ignore: cast_nullable_to_non_nullable
              as String?,
      refinement: freezed == refinement
          ? _value.refinement
          : refinement // ignore: cast_nullable_to_non_nullable
              as RefinementTrace?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GenerationTraceImpl implements _GenerationTrace {
  const _$GenerationTraceImpl(
      {this.retrieval,
      @JsonKey(name: 'base_generation_model') this.baseGenerationModel,
      this.refinement});

  factory _$GenerationTraceImpl.fromJson(Map<String, dynamic> json) =>
      _$$GenerationTraceImplFromJson(json);

  @override
  final RetrievalTrace? retrieval;
  @override
  @JsonKey(name: 'base_generation_model')
  final String? baseGenerationModel;
  @override
  final RefinementTrace? refinement;

  @override
  String toString() {
    return 'GenerationTrace(retrieval: $retrieval, baseGenerationModel: $baseGenerationModel, refinement: $refinement)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenerationTraceImpl &&
            (identical(other.retrieval, retrieval) ||
                other.retrieval == retrieval) &&
            (identical(other.baseGenerationModel, baseGenerationModel) ||
                other.baseGenerationModel == baseGenerationModel) &&
            (identical(other.refinement, refinement) ||
                other.refinement == refinement));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, retrieval, baseGenerationModel, refinement);

  /// Create a copy of GenerationTrace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenerationTraceImplCopyWith<_$GenerationTraceImpl> get copyWith =>
      __$$GenerationTraceImplCopyWithImpl<_$GenerationTraceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GenerationTraceImplToJson(
      this,
    );
  }
}

abstract class _GenerationTrace implements GenerationTrace {
  const factory _GenerationTrace(
      {final RetrievalTrace? retrieval,
      @JsonKey(name: 'base_generation_model') final String? baseGenerationModel,
      final RefinementTrace? refinement}) = _$GenerationTraceImpl;

  factory _GenerationTrace.fromJson(Map<String, dynamic> json) =
      _$GenerationTraceImpl.fromJson;

  @override
  RetrievalTrace? get retrieval;
  @override
  @JsonKey(name: 'base_generation_model')
  String? get baseGenerationModel;
  @override
  RefinementTrace? get refinement;

  /// Create a copy of GenerationTrace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenerationTraceImplCopyWith<_$GenerationTraceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GenerateResponse _$GenerateResponseFromJson(Map<String, dynamic> json) {
  return _GenerateResponse.fromJson(json);
}

/// @nodoc
mixin _$GenerateResponse {
  String get impression => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_impression')
  String get baseImpression => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferences_used')
  int get preferencesUsed => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferences_applied')
  List<AppliedPreference> get preferencesApplied =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'case_id')
  String get caseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_impression_model')
  String? get baseImpressionModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'refinement_model')
  String? get refinementModel => throw _privateConstructorUsedError;
  GenerationTrace? get trace => throw _privateConstructorUsedError;

  /// Serializes this GenerateResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GenerateResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GenerateResponseCopyWith<GenerateResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenerateResponseCopyWith<$Res> {
  factory $GenerateResponseCopyWith(
          GenerateResponse value, $Res Function(GenerateResponse) then) =
      _$GenerateResponseCopyWithImpl<$Res, GenerateResponse>;
  @useResult
  $Res call(
      {String impression,
      @JsonKey(name: 'base_impression') String baseImpression,
      @JsonKey(name: 'preferences_used') int preferencesUsed,
      @JsonKey(name: 'preferences_applied')
      List<AppliedPreference> preferencesApplied,
      @JsonKey(name: 'case_id') String caseId,
      @JsonKey(name: 'base_impression_model') String? baseImpressionModel,
      @JsonKey(name: 'refinement_model') String? refinementModel,
      GenerationTrace? trace});

  $GenerationTraceCopyWith<$Res>? get trace;
}

/// @nodoc
class _$GenerateResponseCopyWithImpl<$Res, $Val extends GenerateResponse>
    implements $GenerateResponseCopyWith<$Res> {
  _$GenerateResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GenerateResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? impression = null,
    Object? baseImpression = null,
    Object? preferencesUsed = null,
    Object? preferencesApplied = null,
    Object? caseId = null,
    Object? baseImpressionModel = freezed,
    Object? refinementModel = freezed,
    Object? trace = freezed,
  }) {
    return _then(_value.copyWith(
      impression: null == impression
          ? _value.impression
          : impression // ignore: cast_nullable_to_non_nullable
              as String,
      baseImpression: null == baseImpression
          ? _value.baseImpression
          : baseImpression // ignore: cast_nullable_to_non_nullable
              as String,
      preferencesUsed: null == preferencesUsed
          ? _value.preferencesUsed
          : preferencesUsed // ignore: cast_nullable_to_non_nullable
              as int,
      preferencesApplied: null == preferencesApplied
          ? _value.preferencesApplied
          : preferencesApplied // ignore: cast_nullable_to_non_nullable
              as List<AppliedPreference>,
      caseId: null == caseId
          ? _value.caseId
          : caseId // ignore: cast_nullable_to_non_nullable
              as String,
      baseImpressionModel: freezed == baseImpressionModel
          ? _value.baseImpressionModel
          : baseImpressionModel // ignore: cast_nullable_to_non_nullable
              as String?,
      refinementModel: freezed == refinementModel
          ? _value.refinementModel
          : refinementModel // ignore: cast_nullable_to_non_nullable
              as String?,
      trace: freezed == trace
          ? _value.trace
          : trace // ignore: cast_nullable_to_non_nullable
              as GenerationTrace?,
    ) as $Val);
  }

  /// Create a copy of GenerateResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GenerationTraceCopyWith<$Res>? get trace {
    if (_value.trace == null) {
      return null;
    }

    return $GenerationTraceCopyWith<$Res>(_value.trace!, (value) {
      return _then(_value.copyWith(trace: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GenerateResponseImplCopyWith<$Res>
    implements $GenerateResponseCopyWith<$Res> {
  factory _$$GenerateResponseImplCopyWith(_$GenerateResponseImpl value,
          $Res Function(_$GenerateResponseImpl) then) =
      __$$GenerateResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String impression,
      @JsonKey(name: 'base_impression') String baseImpression,
      @JsonKey(name: 'preferences_used') int preferencesUsed,
      @JsonKey(name: 'preferences_applied')
      List<AppliedPreference> preferencesApplied,
      @JsonKey(name: 'case_id') String caseId,
      @JsonKey(name: 'base_impression_model') String? baseImpressionModel,
      @JsonKey(name: 'refinement_model') String? refinementModel,
      GenerationTrace? trace});

  @override
  $GenerationTraceCopyWith<$Res>? get trace;
}

/// @nodoc
class __$$GenerateResponseImplCopyWithImpl<$Res>
    extends _$GenerateResponseCopyWithImpl<$Res, _$GenerateResponseImpl>
    implements _$$GenerateResponseImplCopyWith<$Res> {
  __$$GenerateResponseImplCopyWithImpl(_$GenerateResponseImpl _value,
      $Res Function(_$GenerateResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GenerateResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? impression = null,
    Object? baseImpression = null,
    Object? preferencesUsed = null,
    Object? preferencesApplied = null,
    Object? caseId = null,
    Object? baseImpressionModel = freezed,
    Object? refinementModel = freezed,
    Object? trace = freezed,
  }) {
    return _then(_$GenerateResponseImpl(
      impression: null == impression
          ? _value.impression
          : impression // ignore: cast_nullable_to_non_nullable
              as String,
      baseImpression: null == baseImpression
          ? _value.baseImpression
          : baseImpression // ignore: cast_nullable_to_non_nullable
              as String,
      preferencesUsed: null == preferencesUsed
          ? _value.preferencesUsed
          : preferencesUsed // ignore: cast_nullable_to_non_nullable
              as int,
      preferencesApplied: null == preferencesApplied
          ? _value._preferencesApplied
          : preferencesApplied // ignore: cast_nullable_to_non_nullable
              as List<AppliedPreference>,
      caseId: null == caseId
          ? _value.caseId
          : caseId // ignore: cast_nullable_to_non_nullable
              as String,
      baseImpressionModel: freezed == baseImpressionModel
          ? _value.baseImpressionModel
          : baseImpressionModel // ignore: cast_nullable_to_non_nullable
              as String?,
      refinementModel: freezed == refinementModel
          ? _value.refinementModel
          : refinementModel // ignore: cast_nullable_to_non_nullable
              as String?,
      trace: freezed == trace
          ? _value.trace
          : trace // ignore: cast_nullable_to_non_nullable
              as GenerationTrace?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GenerateResponseImpl implements _GenerateResponse {
  const _$GenerateResponseImpl(
      {this.impression = '',
      @JsonKey(name: 'base_impression') this.baseImpression = '',
      @JsonKey(name: 'preferences_used') this.preferencesUsed = 0,
      @JsonKey(name: 'preferences_applied')
      final List<AppliedPreference> preferencesApplied = const [],
      @JsonKey(name: 'case_id') this.caseId = '',
      @JsonKey(name: 'base_impression_model') this.baseImpressionModel,
      @JsonKey(name: 'refinement_model') this.refinementModel,
      this.trace})
      : _preferencesApplied = preferencesApplied;

  factory _$GenerateResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GenerateResponseImplFromJson(json);

  @override
  @JsonKey()
  final String impression;
  @override
  @JsonKey(name: 'base_impression')
  final String baseImpression;
  @override
  @JsonKey(name: 'preferences_used')
  final int preferencesUsed;
  final List<AppliedPreference> _preferencesApplied;
  @override
  @JsonKey(name: 'preferences_applied')
  List<AppliedPreference> get preferencesApplied {
    if (_preferencesApplied is EqualUnmodifiableListView)
      return _preferencesApplied;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferencesApplied);
  }

  @override
  @JsonKey(name: 'case_id')
  final String caseId;
  @override
  @JsonKey(name: 'base_impression_model')
  final String? baseImpressionModel;
  @override
  @JsonKey(name: 'refinement_model')
  final String? refinementModel;
  @override
  final GenerationTrace? trace;

  @override
  String toString() {
    return 'GenerateResponse(impression: $impression, baseImpression: $baseImpression, preferencesUsed: $preferencesUsed, preferencesApplied: $preferencesApplied, caseId: $caseId, baseImpressionModel: $baseImpressionModel, refinementModel: $refinementModel, trace: $trace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenerateResponseImpl &&
            (identical(other.impression, impression) ||
                other.impression == impression) &&
            (identical(other.baseImpression, baseImpression) ||
                other.baseImpression == baseImpression) &&
            (identical(other.preferencesUsed, preferencesUsed) ||
                other.preferencesUsed == preferencesUsed) &&
            const DeepCollectionEquality()
                .equals(other._preferencesApplied, _preferencesApplied) &&
            (identical(other.caseId, caseId) || other.caseId == caseId) &&
            (identical(other.baseImpressionModel, baseImpressionModel) ||
                other.baseImpressionModel == baseImpressionModel) &&
            (identical(other.refinementModel, refinementModel) ||
                other.refinementModel == refinementModel) &&
            (identical(other.trace, trace) || other.trace == trace));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      impression,
      baseImpression,
      preferencesUsed,
      const DeepCollectionEquality().hash(_preferencesApplied),
      caseId,
      baseImpressionModel,
      refinementModel,
      trace);

  /// Create a copy of GenerateResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenerateResponseImplCopyWith<_$GenerateResponseImpl> get copyWith =>
      __$$GenerateResponseImplCopyWithImpl<_$GenerateResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GenerateResponseImplToJson(
      this,
    );
  }
}

abstract class _GenerateResponse implements GenerateResponse {
  const factory _GenerateResponse(
      {final String impression,
      @JsonKey(name: 'base_impression') final String baseImpression,
      @JsonKey(name: 'preferences_used') final int preferencesUsed,
      @JsonKey(name: 'preferences_applied')
      final List<AppliedPreference> preferencesApplied,
      @JsonKey(name: 'case_id') final String caseId,
      @JsonKey(name: 'base_impression_model') final String? baseImpressionModel,
      @JsonKey(name: 'refinement_model') final String? refinementModel,
      final GenerationTrace? trace}) = _$GenerateResponseImpl;

  factory _GenerateResponse.fromJson(Map<String, dynamic> json) =
      _$GenerateResponseImpl.fromJson;

  @override
  String get impression;
  @override
  @JsonKey(name: 'base_impression')
  String get baseImpression;
  @override
  @JsonKey(name: 'preferences_used')
  int get preferencesUsed;
  @override
  @JsonKey(name: 'preferences_applied')
  List<AppliedPreference> get preferencesApplied;
  @override
  @JsonKey(name: 'case_id')
  String get caseId;
  @override
  @JsonKey(name: 'base_impression_model')
  String? get baseImpressionModel;
  @override
  @JsonKey(name: 'refinement_model')
  String? get refinementModel;
  @override
  GenerationTrace? get trace;

  /// Create a copy of GenerateResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenerateResponseImplCopyWith<_$GenerateResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EditRequest _$EditRequestFromJson(Map<String, dynamic> json) {
  return _EditRequest.fromJson(json);
}

/// @nodoc
mixin _$EditRequest {
  @JsonKey(name: 'case_id')
  String get caseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_impression')
  String get originalImpression => throw _privateConstructorUsedError;
  @JsonKey(name: 'edited_impression')
  String get editedImpression => throw _privateConstructorUsedError;
  String get findings => throw _privateConstructorUsedError;
  @JsonKey(name: 'idempotency_key')
  String get idempotencyKey => throw _privateConstructorUsedError;

  /// Serializes this EditRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EditRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EditRequestCopyWith<EditRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditRequestCopyWith<$Res> {
  factory $EditRequestCopyWith(
          EditRequest value, $Res Function(EditRequest) then) =
      _$EditRequestCopyWithImpl<$Res, EditRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'case_id') String caseId,
      @JsonKey(name: 'original_impression') String originalImpression,
      @JsonKey(name: 'edited_impression') String editedImpression,
      String findings,
      @JsonKey(name: 'idempotency_key') String idempotencyKey});
}

/// @nodoc
class _$EditRequestCopyWithImpl<$Res, $Val extends EditRequest>
    implements $EditRequestCopyWith<$Res> {
  _$EditRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EditRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caseId = null,
    Object? originalImpression = null,
    Object? editedImpression = null,
    Object? findings = null,
    Object? idempotencyKey = null,
  }) {
    return _then(_value.copyWith(
      caseId: null == caseId
          ? _value.caseId
          : caseId // ignore: cast_nullable_to_non_nullable
              as String,
      originalImpression: null == originalImpression
          ? _value.originalImpression
          : originalImpression // ignore: cast_nullable_to_non_nullable
              as String,
      editedImpression: null == editedImpression
          ? _value.editedImpression
          : editedImpression // ignore: cast_nullable_to_non_nullable
              as String,
      findings: null == findings
          ? _value.findings
          : findings // ignore: cast_nullable_to_non_nullable
              as String,
      idempotencyKey: null == idempotencyKey
          ? _value.idempotencyKey
          : idempotencyKey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EditRequestImplCopyWith<$Res>
    implements $EditRequestCopyWith<$Res> {
  factory _$$EditRequestImplCopyWith(
          _$EditRequestImpl value, $Res Function(_$EditRequestImpl) then) =
      __$$EditRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'case_id') String caseId,
      @JsonKey(name: 'original_impression') String originalImpression,
      @JsonKey(name: 'edited_impression') String editedImpression,
      String findings,
      @JsonKey(name: 'idempotency_key') String idempotencyKey});
}

/// @nodoc
class __$$EditRequestImplCopyWithImpl<$Res>
    extends _$EditRequestCopyWithImpl<$Res, _$EditRequestImpl>
    implements _$$EditRequestImplCopyWith<$Res> {
  __$$EditRequestImplCopyWithImpl(
      _$EditRequestImpl _value, $Res Function(_$EditRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of EditRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caseId = null,
    Object? originalImpression = null,
    Object? editedImpression = null,
    Object? findings = null,
    Object? idempotencyKey = null,
  }) {
    return _then(_$EditRequestImpl(
      caseId: null == caseId
          ? _value.caseId
          : caseId // ignore: cast_nullable_to_non_nullable
              as String,
      originalImpression: null == originalImpression
          ? _value.originalImpression
          : originalImpression // ignore: cast_nullable_to_non_nullable
              as String,
      editedImpression: null == editedImpression
          ? _value.editedImpression
          : editedImpression // ignore: cast_nullable_to_non_nullable
              as String,
      findings: null == findings
          ? _value.findings
          : findings // ignore: cast_nullable_to_non_nullable
              as String,
      idempotencyKey: null == idempotencyKey
          ? _value.idempotencyKey
          : idempotencyKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EditRequestImpl implements _EditRequest {
  const _$EditRequestImpl(
      {@JsonKey(name: 'case_id') required this.caseId,
      @JsonKey(name: 'original_impression') required this.originalImpression,
      @JsonKey(name: 'edited_impression') required this.editedImpression,
      required this.findings,
      @JsonKey(name: 'idempotency_key') required this.idempotencyKey});

  factory _$EditRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$EditRequestImplFromJson(json);

  @override
  @JsonKey(name: 'case_id')
  final String caseId;
  @override
  @JsonKey(name: 'original_impression')
  final String originalImpression;
  @override
  @JsonKey(name: 'edited_impression')
  final String editedImpression;
  @override
  final String findings;
  @override
  @JsonKey(name: 'idempotency_key')
  final String idempotencyKey;

  @override
  String toString() {
    return 'EditRequest(caseId: $caseId, originalImpression: $originalImpression, editedImpression: $editedImpression, findings: $findings, idempotencyKey: $idempotencyKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditRequestImpl &&
            (identical(other.caseId, caseId) || other.caseId == caseId) &&
            (identical(other.originalImpression, originalImpression) ||
                other.originalImpression == originalImpression) &&
            (identical(other.editedImpression, editedImpression) ||
                other.editedImpression == editedImpression) &&
            (identical(other.findings, findings) ||
                other.findings == findings) &&
            (identical(other.idempotencyKey, idempotencyKey) ||
                other.idempotencyKey == idempotencyKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, caseId, originalImpression,
      editedImpression, findings, idempotencyKey);

  /// Create a copy of EditRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EditRequestImplCopyWith<_$EditRequestImpl> get copyWith =>
      __$$EditRequestImplCopyWithImpl<_$EditRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EditRequestImplToJson(
      this,
    );
  }
}

abstract class _EditRequest implements EditRequest {
  const factory _EditRequest(
      {@JsonKey(name: 'case_id') required final String caseId,
      @JsonKey(name: 'original_impression')
      required final String originalImpression,
      @JsonKey(name: 'edited_impression')
      required final String editedImpression,
      required final String findings,
      @JsonKey(name: 'idempotency_key')
      required final String idempotencyKey}) = _$EditRequestImpl;

  factory _EditRequest.fromJson(Map<String, dynamic> json) =
      _$EditRequestImpl.fromJson;

  @override
  @JsonKey(name: 'case_id')
  String get caseId;
  @override
  @JsonKey(name: 'original_impression')
  String get originalImpression;
  @override
  @JsonKey(name: 'edited_impression')
  String get editedImpression;
  @override
  String get findings;
  @override
  @JsonKey(name: 'idempotency_key')
  String get idempotencyKey;

  /// Create a copy of EditRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EditRequestImplCopyWith<_$EditRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EditStartResponse _$EditStartResponseFromJson(Map<String, dynamic> json) {
  return _EditStartResponse.fromJson(json);
}

/// @nodoc
mixin _$EditStartResponse {
  @JsonKey(name: 'edit_id')
  String get editId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'poll_url')
  String get pollUrl => throw _privateConstructorUsedError;

  /// Serializes this EditStartResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EditStartResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EditStartResponseCopyWith<EditStartResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditStartResponseCopyWith<$Res> {
  factory $EditStartResponseCopyWith(
          EditStartResponse value, $Res Function(EditStartResponse) then) =
      _$EditStartResponseCopyWithImpl<$Res, EditStartResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'edit_id') String editId,
      String status,
      @JsonKey(name: 'poll_url') String pollUrl});
}

/// @nodoc
class _$EditStartResponseCopyWithImpl<$Res, $Val extends EditStartResponse>
    implements $EditStartResponseCopyWith<$Res> {
  _$EditStartResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EditStartResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? editId = null,
    Object? status = null,
    Object? pollUrl = null,
  }) {
    return _then(_value.copyWith(
      editId: null == editId
          ? _value.editId
          : editId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      pollUrl: null == pollUrl
          ? _value.pollUrl
          : pollUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EditStartResponseImplCopyWith<$Res>
    implements $EditStartResponseCopyWith<$Res> {
  factory _$$EditStartResponseImplCopyWith(_$EditStartResponseImpl value,
          $Res Function(_$EditStartResponseImpl) then) =
      __$$EditStartResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'edit_id') String editId,
      String status,
      @JsonKey(name: 'poll_url') String pollUrl});
}

/// @nodoc
class __$$EditStartResponseImplCopyWithImpl<$Res>
    extends _$EditStartResponseCopyWithImpl<$Res, _$EditStartResponseImpl>
    implements _$$EditStartResponseImplCopyWith<$Res> {
  __$$EditStartResponseImplCopyWithImpl(_$EditStartResponseImpl _value,
      $Res Function(_$EditStartResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of EditStartResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? editId = null,
    Object? status = null,
    Object? pollUrl = null,
  }) {
    return _then(_$EditStartResponseImpl(
      editId: null == editId
          ? _value.editId
          : editId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      pollUrl: null == pollUrl
          ? _value.pollUrl
          : pollUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EditStartResponseImpl implements _EditStartResponse {
  const _$EditStartResponseImpl(
      {@JsonKey(name: 'edit_id') this.editId = '',
      this.status = 'pending',
      @JsonKey(name: 'poll_url') this.pollUrl = ''});

  factory _$EditStartResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$EditStartResponseImplFromJson(json);

  @override
  @JsonKey(name: 'edit_id')
  final String editId;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'poll_url')
  final String pollUrl;

  @override
  String toString() {
    return 'EditStartResponse(editId: $editId, status: $status, pollUrl: $pollUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditStartResponseImpl &&
            (identical(other.editId, editId) || other.editId == editId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.pollUrl, pollUrl) || other.pollUrl == pollUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, editId, status, pollUrl);

  /// Create a copy of EditStartResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EditStartResponseImplCopyWith<_$EditStartResponseImpl> get copyWith =>
      __$$EditStartResponseImplCopyWithImpl<_$EditStartResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EditStartResponseImplToJson(
      this,
    );
  }
}

abstract class _EditStartResponse implements EditStartResponse {
  const factory _EditStartResponse(
          {@JsonKey(name: 'edit_id') final String editId,
          final String status,
          @JsonKey(name: 'poll_url') final String pollUrl}) =
      _$EditStartResponseImpl;

  factory _EditStartResponse.fromJson(Map<String, dynamic> json) =
      _$EditStartResponseImpl.fromJson;

  @override
  @JsonKey(name: 'edit_id')
  String get editId;
  @override
  String get status;
  @override
  @JsonKey(name: 'poll_url')
  String get pollUrl;

  /// Create a copy of EditStartResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EditStartResponseImplCopyWith<_$EditStartResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SavedPreferenceInfo _$SavedPreferenceInfoFromJson(Map<String, dynamic> json) {
  return _SavedPreferenceInfo.fromJson(json);
}

/// @nodoc
mixin _$SavedPreferenceInfo {
  @JsonKey(name: 'preference_id')
  String get preferenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'preference_text')
  String get preferenceText => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  double? get confidence => throw _privateConstructorUsedError;

  /// Serializes this SavedPreferenceInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedPreferenceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedPreferenceInfoCopyWith<SavedPreferenceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedPreferenceInfoCopyWith<$Res> {
  factory $SavedPreferenceInfoCopyWith(
          SavedPreferenceInfo value, $Res Function(SavedPreferenceInfo) then) =
      _$SavedPreferenceInfoCopyWithImpl<$Res, SavedPreferenceInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'preference_id') String preferenceId,
      @JsonKey(name: 'preference_text') String preferenceText,
      String? category,
      double? confidence});
}

/// @nodoc
class _$SavedPreferenceInfoCopyWithImpl<$Res, $Val extends SavedPreferenceInfo>
    implements $SavedPreferenceInfoCopyWith<$Res> {
  _$SavedPreferenceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedPreferenceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferenceId = null,
    Object? preferenceText = null,
    Object? category = freezed,
    Object? confidence = freezed,
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
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SavedPreferenceInfoImplCopyWith<$Res>
    implements $SavedPreferenceInfoCopyWith<$Res> {
  factory _$$SavedPreferenceInfoImplCopyWith(_$SavedPreferenceInfoImpl value,
          $Res Function(_$SavedPreferenceInfoImpl) then) =
      __$$SavedPreferenceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'preference_id') String preferenceId,
      @JsonKey(name: 'preference_text') String preferenceText,
      String? category,
      double? confidence});
}

/// @nodoc
class __$$SavedPreferenceInfoImplCopyWithImpl<$Res>
    extends _$SavedPreferenceInfoCopyWithImpl<$Res, _$SavedPreferenceInfoImpl>
    implements _$$SavedPreferenceInfoImplCopyWith<$Res> {
  __$$SavedPreferenceInfoImplCopyWithImpl(_$SavedPreferenceInfoImpl _value,
      $Res Function(_$SavedPreferenceInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavedPreferenceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferenceId = null,
    Object? preferenceText = null,
    Object? category = freezed,
    Object? confidence = freezed,
  }) {
    return _then(_$SavedPreferenceInfoImpl(
      preferenceId: null == preferenceId
          ? _value.preferenceId
          : preferenceId // ignore: cast_nullable_to_non_nullable
              as String,
      preferenceText: null == preferenceText
          ? _value.preferenceText
          : preferenceText // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedPreferenceInfoImpl implements _SavedPreferenceInfo {
  const _$SavedPreferenceInfoImpl(
      {@JsonKey(name: 'preference_id') this.preferenceId = '',
      @JsonKey(name: 'preference_text') this.preferenceText = '',
      this.category,
      this.confidence});

  factory _$SavedPreferenceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedPreferenceInfoImplFromJson(json);

  @override
  @JsonKey(name: 'preference_id')
  final String preferenceId;
  @override
  @JsonKey(name: 'preference_text')
  final String preferenceText;
  @override
  final String? category;
  @override
  final double? confidence;

  @override
  String toString() {
    return 'SavedPreferenceInfo(preferenceId: $preferenceId, preferenceText: $preferenceText, category: $category, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedPreferenceInfoImpl &&
            (identical(other.preferenceId, preferenceId) ||
                other.preferenceId == preferenceId) &&
            (identical(other.preferenceText, preferenceText) ||
                other.preferenceText == preferenceText) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, preferenceId, preferenceText, category, confidence);

  /// Create a copy of SavedPreferenceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedPreferenceInfoImplCopyWith<_$SavedPreferenceInfoImpl> get copyWith =>
      __$$SavedPreferenceInfoImplCopyWithImpl<_$SavedPreferenceInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedPreferenceInfoImplToJson(
      this,
    );
  }
}

abstract class _SavedPreferenceInfo implements SavedPreferenceInfo {
  const factory _SavedPreferenceInfo(
      {@JsonKey(name: 'preference_id') final String preferenceId,
      @JsonKey(name: 'preference_text') final String preferenceText,
      final String? category,
      final double? confidence}) = _$SavedPreferenceInfoImpl;

  factory _SavedPreferenceInfo.fromJson(Map<String, dynamic> json) =
      _$SavedPreferenceInfoImpl.fromJson;

  @override
  @JsonKey(name: 'preference_id')
  String get preferenceId;
  @override
  @JsonKey(name: 'preference_text')
  String get preferenceText;
  @override
  String? get category;
  @override
  double? get confidence;

  /// Create a copy of SavedPreferenceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedPreferenceInfoImplCopyWith<_$SavedPreferenceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RejectedChangeInfo _$RejectedChangeInfoFromJson(Map<String, dynamic> json) {
  return _RejectedChangeInfo.fromJson(json);
}

/// @nodoc
mixin _$RejectedChangeInfo {
  @JsonKey(name: 'change_description')
  String get changeDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejection_reason')
  String get reason => throw _privateConstructorUsedError;
  @JsonKey(name: 'risk_level')
  String? get riskLevel => throw _privateConstructorUsedError;

  /// Serializes this RejectedChangeInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RejectedChangeInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RejectedChangeInfoCopyWith<RejectedChangeInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RejectedChangeInfoCopyWith<$Res> {
  factory $RejectedChangeInfoCopyWith(
          RejectedChangeInfo value, $Res Function(RejectedChangeInfo) then) =
      _$RejectedChangeInfoCopyWithImpl<$Res, RejectedChangeInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'change_description') String changeDescription,
      @JsonKey(name: 'rejection_reason') String reason,
      @JsonKey(name: 'risk_level') String? riskLevel});
}

/// @nodoc
class _$RejectedChangeInfoCopyWithImpl<$Res, $Val extends RejectedChangeInfo>
    implements $RejectedChangeInfoCopyWith<$Res> {
  _$RejectedChangeInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RejectedChangeInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? changeDescription = null,
    Object? reason = null,
    Object? riskLevel = freezed,
  }) {
    return _then(_value.copyWith(
      changeDescription: null == changeDescription
          ? _value.changeDescription
          : changeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      riskLevel: freezed == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RejectedChangeInfoImplCopyWith<$Res>
    implements $RejectedChangeInfoCopyWith<$Res> {
  factory _$$RejectedChangeInfoImplCopyWith(_$RejectedChangeInfoImpl value,
          $Res Function(_$RejectedChangeInfoImpl) then) =
      __$$RejectedChangeInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'change_description') String changeDescription,
      @JsonKey(name: 'rejection_reason') String reason,
      @JsonKey(name: 'risk_level') String? riskLevel});
}

/// @nodoc
class __$$RejectedChangeInfoImplCopyWithImpl<$Res>
    extends _$RejectedChangeInfoCopyWithImpl<$Res, _$RejectedChangeInfoImpl>
    implements _$$RejectedChangeInfoImplCopyWith<$Res> {
  __$$RejectedChangeInfoImplCopyWithImpl(_$RejectedChangeInfoImpl _value,
      $Res Function(_$RejectedChangeInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of RejectedChangeInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? changeDescription = null,
    Object? reason = null,
    Object? riskLevel = freezed,
  }) {
    return _then(_$RejectedChangeInfoImpl(
      changeDescription: null == changeDescription
          ? _value.changeDescription
          : changeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      riskLevel: freezed == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RejectedChangeInfoImpl implements _RejectedChangeInfo {
  const _$RejectedChangeInfoImpl(
      {@JsonKey(name: 'change_description') this.changeDescription = '',
      @JsonKey(name: 'rejection_reason') this.reason = '',
      @JsonKey(name: 'risk_level') this.riskLevel});

  factory _$RejectedChangeInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RejectedChangeInfoImplFromJson(json);

  @override
  @JsonKey(name: 'change_description')
  final String changeDescription;
  @override
  @JsonKey(name: 'rejection_reason')
  final String reason;
  @override
  @JsonKey(name: 'risk_level')
  final String? riskLevel;

  @override
  String toString() {
    return 'RejectedChangeInfo(changeDescription: $changeDescription, reason: $reason, riskLevel: $riskLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RejectedChangeInfoImpl &&
            (identical(other.changeDescription, changeDescription) ||
                other.changeDescription == changeDescription) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, changeDescription, reason, riskLevel);

  /// Create a copy of RejectedChangeInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RejectedChangeInfoImplCopyWith<_$RejectedChangeInfoImpl> get copyWith =>
      __$$RejectedChangeInfoImplCopyWithImpl<_$RejectedChangeInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RejectedChangeInfoImplToJson(
      this,
    );
  }
}

abstract class _RejectedChangeInfo implements RejectedChangeInfo {
  const factory _RejectedChangeInfo(
          {@JsonKey(name: 'change_description') final String changeDescription,
          @JsonKey(name: 'rejection_reason') final String reason,
          @JsonKey(name: 'risk_level') final String? riskLevel}) =
      _$RejectedChangeInfoImpl;

  factory _RejectedChangeInfo.fromJson(Map<String, dynamic> json) =
      _$RejectedChangeInfoImpl.fromJson;

  @override
  @JsonKey(name: 'change_description')
  String get changeDescription;
  @override
  @JsonKey(name: 'rejection_reason')
  String get reason;
  @override
  @JsonKey(name: 'risk_level')
  String? get riskLevel;

  /// Create a copy of RejectedChangeInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RejectedChangeInfoImplCopyWith<_$RejectedChangeInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EditStatusResponse _$EditStatusResponseFromJson(Map<String, dynamic> json) {
  return _EditStatusResponse.fromJson(json);
}

/// @nodoc
mixin _$EditStatusResponse {
  @JsonKey(name: 'edit_id')
  String get editId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'edit_distance')
  double? get editDistance => throw _privateConstructorUsedError;
  @JsonKey(name: 'preference_inferred')
  bool? get preferenceInferred => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferences_saved')
  List<SavedPreferenceInfo>? get preferencesSaved =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'changes_rejected')
  List<RejectedChangeInfo>? get changesRejected =>
      throw _privateConstructorUsedError;
  String? get summary => throw _privateConstructorUsedError;
  @JsonKey(name: 'safety_warning')
  String? get safetyWarning => throw _privateConstructorUsedError;
  @JsonKey(name: 'error_message')
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this EditStatusResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EditStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EditStatusResponseCopyWith<EditStatusResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditStatusResponseCopyWith<$Res> {
  factory $EditStatusResponseCopyWith(
          EditStatusResponse value, $Res Function(EditStatusResponse) then) =
      _$EditStatusResponseCopyWithImpl<$Res, EditStatusResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'edit_id') String editId,
      String status,
      @JsonKey(name: 'edit_distance') double? editDistance,
      @JsonKey(name: 'preference_inferred') bool? preferenceInferred,
      @JsonKey(name: 'preferences_saved')
      List<SavedPreferenceInfo>? preferencesSaved,
      @JsonKey(name: 'changes_rejected')
      List<RejectedChangeInfo>? changesRejected,
      String? summary,
      @JsonKey(name: 'safety_warning') String? safetyWarning,
      @JsonKey(name: 'error_message') String? errorMessage});
}

/// @nodoc
class _$EditStatusResponseCopyWithImpl<$Res, $Val extends EditStatusResponse>
    implements $EditStatusResponseCopyWith<$Res> {
  _$EditStatusResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EditStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? editId = null,
    Object? status = null,
    Object? editDistance = freezed,
    Object? preferenceInferred = freezed,
    Object? preferencesSaved = freezed,
    Object? changesRejected = freezed,
    Object? summary = freezed,
    Object? safetyWarning = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      editId: null == editId
          ? _value.editId
          : editId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      editDistance: freezed == editDistance
          ? _value.editDistance
          : editDistance // ignore: cast_nullable_to_non_nullable
              as double?,
      preferenceInferred: freezed == preferenceInferred
          ? _value.preferenceInferred
          : preferenceInferred // ignore: cast_nullable_to_non_nullable
              as bool?,
      preferencesSaved: freezed == preferencesSaved
          ? _value.preferencesSaved
          : preferencesSaved // ignore: cast_nullable_to_non_nullable
              as List<SavedPreferenceInfo>?,
      changesRejected: freezed == changesRejected
          ? _value.changesRejected
          : changesRejected // ignore: cast_nullable_to_non_nullable
              as List<RejectedChangeInfo>?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      safetyWarning: freezed == safetyWarning
          ? _value.safetyWarning
          : safetyWarning // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EditStatusResponseImplCopyWith<$Res>
    implements $EditStatusResponseCopyWith<$Res> {
  factory _$$EditStatusResponseImplCopyWith(_$EditStatusResponseImpl value,
          $Res Function(_$EditStatusResponseImpl) then) =
      __$$EditStatusResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'edit_id') String editId,
      String status,
      @JsonKey(name: 'edit_distance') double? editDistance,
      @JsonKey(name: 'preference_inferred') bool? preferenceInferred,
      @JsonKey(name: 'preferences_saved')
      List<SavedPreferenceInfo>? preferencesSaved,
      @JsonKey(name: 'changes_rejected')
      List<RejectedChangeInfo>? changesRejected,
      String? summary,
      @JsonKey(name: 'safety_warning') String? safetyWarning,
      @JsonKey(name: 'error_message') String? errorMessage});
}

/// @nodoc
class __$$EditStatusResponseImplCopyWithImpl<$Res>
    extends _$EditStatusResponseCopyWithImpl<$Res, _$EditStatusResponseImpl>
    implements _$$EditStatusResponseImplCopyWith<$Res> {
  __$$EditStatusResponseImplCopyWithImpl(_$EditStatusResponseImpl _value,
      $Res Function(_$EditStatusResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of EditStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? editId = null,
    Object? status = null,
    Object? editDistance = freezed,
    Object? preferenceInferred = freezed,
    Object? preferencesSaved = freezed,
    Object? changesRejected = freezed,
    Object? summary = freezed,
    Object? safetyWarning = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$EditStatusResponseImpl(
      editId: null == editId
          ? _value.editId
          : editId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      editDistance: freezed == editDistance
          ? _value.editDistance
          : editDistance // ignore: cast_nullable_to_non_nullable
              as double?,
      preferenceInferred: freezed == preferenceInferred
          ? _value.preferenceInferred
          : preferenceInferred // ignore: cast_nullable_to_non_nullable
              as bool?,
      preferencesSaved: freezed == preferencesSaved
          ? _value._preferencesSaved
          : preferencesSaved // ignore: cast_nullable_to_non_nullable
              as List<SavedPreferenceInfo>?,
      changesRejected: freezed == changesRejected
          ? _value._changesRejected
          : changesRejected // ignore: cast_nullable_to_non_nullable
              as List<RejectedChangeInfo>?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      safetyWarning: freezed == safetyWarning
          ? _value.safetyWarning
          : safetyWarning // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EditStatusResponseImpl extends _EditStatusResponse {
  const _$EditStatusResponseImpl(
      {@JsonKey(name: 'edit_id') this.editId = '',
      this.status = 'pending',
      @JsonKey(name: 'edit_distance') this.editDistance,
      @JsonKey(name: 'preference_inferred') this.preferenceInferred,
      @JsonKey(name: 'preferences_saved')
      final List<SavedPreferenceInfo>? preferencesSaved,
      @JsonKey(name: 'changes_rejected')
      final List<RejectedChangeInfo>? changesRejected,
      this.summary,
      @JsonKey(name: 'safety_warning') this.safetyWarning,
      @JsonKey(name: 'error_message') this.errorMessage})
      : _preferencesSaved = preferencesSaved,
        _changesRejected = changesRejected,
        super._();

  factory _$EditStatusResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$EditStatusResponseImplFromJson(json);

  @override
  @JsonKey(name: 'edit_id')
  final String editId;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'edit_distance')
  final double? editDistance;
  @override
  @JsonKey(name: 'preference_inferred')
  final bool? preferenceInferred;
  final List<SavedPreferenceInfo>? _preferencesSaved;
  @override
  @JsonKey(name: 'preferences_saved')
  List<SavedPreferenceInfo>? get preferencesSaved {
    final value = _preferencesSaved;
    if (value == null) return null;
    if (_preferencesSaved is EqualUnmodifiableListView)
      return _preferencesSaved;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<RejectedChangeInfo>? _changesRejected;
  @override
  @JsonKey(name: 'changes_rejected')
  List<RejectedChangeInfo>? get changesRejected {
    final value = _changesRejected;
    if (value == null) return null;
    if (_changesRejected is EqualUnmodifiableListView) return _changesRejected;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? summary;
  @override
  @JsonKey(name: 'safety_warning')
  final String? safetyWarning;
  @override
  @JsonKey(name: 'error_message')
  final String? errorMessage;

  @override
  String toString() {
    return 'EditStatusResponse(editId: $editId, status: $status, editDistance: $editDistance, preferenceInferred: $preferenceInferred, preferencesSaved: $preferencesSaved, changesRejected: $changesRejected, summary: $summary, safetyWarning: $safetyWarning, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditStatusResponseImpl &&
            (identical(other.editId, editId) || other.editId == editId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.editDistance, editDistance) ||
                other.editDistance == editDistance) &&
            (identical(other.preferenceInferred, preferenceInferred) ||
                other.preferenceInferred == preferenceInferred) &&
            const DeepCollectionEquality()
                .equals(other._preferencesSaved, _preferencesSaved) &&
            const DeepCollectionEquality()
                .equals(other._changesRejected, _changesRejected) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.safetyWarning, safetyWarning) ||
                other.safetyWarning == safetyWarning) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      editId,
      status,
      editDistance,
      preferenceInferred,
      const DeepCollectionEquality().hash(_preferencesSaved),
      const DeepCollectionEquality().hash(_changesRejected),
      summary,
      safetyWarning,
      errorMessage);

  /// Create a copy of EditStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EditStatusResponseImplCopyWith<_$EditStatusResponseImpl> get copyWith =>
      __$$EditStatusResponseImplCopyWithImpl<_$EditStatusResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EditStatusResponseImplToJson(
      this,
    );
  }
}

abstract class _EditStatusResponse extends EditStatusResponse {
  const factory _EditStatusResponse(
          {@JsonKey(name: 'edit_id') final String editId,
          final String status,
          @JsonKey(name: 'edit_distance') final double? editDistance,
          @JsonKey(name: 'preference_inferred') final bool? preferenceInferred,
          @JsonKey(name: 'preferences_saved')
          final List<SavedPreferenceInfo>? preferencesSaved,
          @JsonKey(name: 'changes_rejected')
          final List<RejectedChangeInfo>? changesRejected,
          final String? summary,
          @JsonKey(name: 'safety_warning') final String? safetyWarning,
          @JsonKey(name: 'error_message') final String? errorMessage}) =
      _$EditStatusResponseImpl;
  const _EditStatusResponse._() : super._();

  factory _EditStatusResponse.fromJson(Map<String, dynamic> json) =
      _$EditStatusResponseImpl.fromJson;

  @override
  @JsonKey(name: 'edit_id')
  String get editId;
  @override
  String get status;
  @override
  @JsonKey(name: 'edit_distance')
  double? get editDistance;
  @override
  @JsonKey(name: 'preference_inferred')
  bool? get preferenceInferred;
  @override
  @JsonKey(name: 'preferences_saved')
  List<SavedPreferenceInfo>? get preferencesSaved;
  @override
  @JsonKey(name: 'changes_rejected')
  List<RejectedChangeInfo>? get changesRejected;
  @override
  String? get summary;
  @override
  @JsonKey(name: 'safety_warning')
  String? get safetyWarning;
  @override
  @JsonKey(name: 'error_message')
  String? get errorMessage;

  /// Create a copy of EditStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EditStatusResponseImplCopyWith<_$EditStatusResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateCaseRequest _$UpdateCaseRequestFromJson(Map<String, dynamic> json) {
  return _UpdateCaseRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateCaseRequest {
  String get findings => throw _privateConstructorUsedError;

  /// Serializes this UpdateCaseRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateCaseRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateCaseRequestCopyWith<UpdateCaseRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateCaseRequestCopyWith<$Res> {
  factory $UpdateCaseRequestCopyWith(
          UpdateCaseRequest value, $Res Function(UpdateCaseRequest) then) =
      _$UpdateCaseRequestCopyWithImpl<$Res, UpdateCaseRequest>;
  @useResult
  $Res call({String findings});
}

/// @nodoc
class _$UpdateCaseRequestCopyWithImpl<$Res, $Val extends UpdateCaseRequest>
    implements $UpdateCaseRequestCopyWith<$Res> {
  _$UpdateCaseRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateCaseRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? findings = null,
  }) {
    return _then(_value.copyWith(
      findings: null == findings
          ? _value.findings
          : findings // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateCaseRequestImplCopyWith<$Res>
    implements $UpdateCaseRequestCopyWith<$Res> {
  factory _$$UpdateCaseRequestImplCopyWith(_$UpdateCaseRequestImpl value,
          $Res Function(_$UpdateCaseRequestImpl) then) =
      __$$UpdateCaseRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String findings});
}

/// @nodoc
class __$$UpdateCaseRequestImplCopyWithImpl<$Res>
    extends _$UpdateCaseRequestCopyWithImpl<$Res, _$UpdateCaseRequestImpl>
    implements _$$UpdateCaseRequestImplCopyWith<$Res> {
  __$$UpdateCaseRequestImplCopyWithImpl(_$UpdateCaseRequestImpl _value,
      $Res Function(_$UpdateCaseRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateCaseRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? findings = null,
  }) {
    return _then(_$UpdateCaseRequestImpl(
      findings: null == findings
          ? _value.findings
          : findings // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateCaseRequestImpl implements _UpdateCaseRequest {
  const _$UpdateCaseRequestImpl({required this.findings});

  factory _$UpdateCaseRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateCaseRequestImplFromJson(json);

  @override
  final String findings;

  @override
  String toString() {
    return 'UpdateCaseRequest(findings: $findings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateCaseRequestImpl &&
            (identical(other.findings, findings) ||
                other.findings == findings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, findings);

  /// Create a copy of UpdateCaseRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateCaseRequestImplCopyWith<_$UpdateCaseRequestImpl> get copyWith =>
      __$$UpdateCaseRequestImplCopyWithImpl<_$UpdateCaseRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateCaseRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateCaseRequest implements UpdateCaseRequest {
  const factory _UpdateCaseRequest({required final String findings}) =
      _$UpdateCaseRequestImpl;

  factory _UpdateCaseRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateCaseRequestImpl.fromJson;

  @override
  String get findings;

  /// Create a copy of UpdateCaseRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateCaseRequestImplCopyWith<_$UpdateCaseRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateCaseResponse _$UpdateCaseResponseFromJson(Map<String, dynamic> json) {
  return _UpdateCaseResponse.fromJson(json);
}

/// @nodoc
mixin _$UpdateCaseResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'case_id')
  String? get caseId => throw _privateConstructorUsedError;

  /// Serializes this UpdateCaseResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateCaseResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateCaseResponseCopyWith<UpdateCaseResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateCaseResponseCopyWith<$Res> {
  factory $UpdateCaseResponseCopyWith(
          UpdateCaseResponse value, $Res Function(UpdateCaseResponse) then) =
      _$UpdateCaseResponseCopyWithImpl<$Res, UpdateCaseResponse>;
  @useResult
  $Res call(
      {bool success,
      String? message,
      @JsonKey(name: 'case_id') String? caseId});
}

/// @nodoc
class _$UpdateCaseResponseCopyWithImpl<$Res, $Val extends UpdateCaseResponse>
    implements $UpdateCaseResponseCopyWith<$Res> {
  _$UpdateCaseResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateCaseResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? caseId = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      caseId: freezed == caseId
          ? _value.caseId
          : caseId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateCaseResponseImplCopyWith<$Res>
    implements $UpdateCaseResponseCopyWith<$Res> {
  factory _$$UpdateCaseResponseImplCopyWith(_$UpdateCaseResponseImpl value,
          $Res Function(_$UpdateCaseResponseImpl) then) =
      __$$UpdateCaseResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String? message,
      @JsonKey(name: 'case_id') String? caseId});
}

/// @nodoc
class __$$UpdateCaseResponseImplCopyWithImpl<$Res>
    extends _$UpdateCaseResponseCopyWithImpl<$Res, _$UpdateCaseResponseImpl>
    implements _$$UpdateCaseResponseImplCopyWith<$Res> {
  __$$UpdateCaseResponseImplCopyWithImpl(_$UpdateCaseResponseImpl _value,
      $Res Function(_$UpdateCaseResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateCaseResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? caseId = freezed,
  }) {
    return _then(_$UpdateCaseResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      caseId: freezed == caseId
          ? _value.caseId
          : caseId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateCaseResponseImpl implements _UpdateCaseResponse {
  const _$UpdateCaseResponseImpl(
      {this.success = true,
      this.message,
      @JsonKey(name: 'case_id') this.caseId});

  factory _$UpdateCaseResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateCaseResponseImplFromJson(json);

  @override
  @JsonKey()
  final bool success;
  @override
  final String? message;
  @override
  @JsonKey(name: 'case_id')
  final String? caseId;

  @override
  String toString() {
    return 'UpdateCaseResponse(success: $success, message: $message, caseId: $caseId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateCaseResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.caseId, caseId) || other.caseId == caseId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, message, caseId);

  /// Create a copy of UpdateCaseResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateCaseResponseImplCopyWith<_$UpdateCaseResponseImpl> get copyWith =>
      __$$UpdateCaseResponseImplCopyWithImpl<_$UpdateCaseResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateCaseResponseImplToJson(
      this,
    );
  }
}

abstract class _UpdateCaseResponse implements UpdateCaseResponse {
  const factory _UpdateCaseResponse(
          {final bool success,
          final String? message,
          @JsonKey(name: 'case_id') final String? caseId}) =
      _$UpdateCaseResponseImpl;

  factory _UpdateCaseResponse.fromJson(Map<String, dynamic> json) =
      _$UpdateCaseResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get message;
  @override
  @JsonKey(name: 'case_id')
  String? get caseId;

  /// Create a copy of UpdateCaseResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateCaseResponseImplCopyWith<_$UpdateCaseResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdatePreferenceRequest _$UpdatePreferenceRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdatePreferenceRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdatePreferenceRequest {
  @JsonKey(name: 'preference_text')
  String get preferenceText => throw _privateConstructorUsedError;

  /// Serializes this UpdatePreferenceRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdatePreferenceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdatePreferenceRequestCopyWith<UpdatePreferenceRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdatePreferenceRequestCopyWith<$Res> {
  factory $UpdatePreferenceRequestCopyWith(UpdatePreferenceRequest value,
          $Res Function(UpdatePreferenceRequest) then) =
      _$UpdatePreferenceRequestCopyWithImpl<$Res, UpdatePreferenceRequest>;
  @useResult
  $Res call({@JsonKey(name: 'preference_text') String preferenceText});
}

/// @nodoc
class _$UpdatePreferenceRequestCopyWithImpl<$Res,
        $Val extends UpdatePreferenceRequest>
    implements $UpdatePreferenceRequestCopyWith<$Res> {
  _$UpdatePreferenceRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdatePreferenceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferenceText = null,
  }) {
    return _then(_value.copyWith(
      preferenceText: null == preferenceText
          ? _value.preferenceText
          : preferenceText // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdatePreferenceRequestImplCopyWith<$Res>
    implements $UpdatePreferenceRequestCopyWith<$Res> {
  factory _$$UpdatePreferenceRequestImplCopyWith(
          _$UpdatePreferenceRequestImpl value,
          $Res Function(_$UpdatePreferenceRequestImpl) then) =
      __$$UpdatePreferenceRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'preference_text') String preferenceText});
}

/// @nodoc
class __$$UpdatePreferenceRequestImplCopyWithImpl<$Res>
    extends _$UpdatePreferenceRequestCopyWithImpl<$Res,
        _$UpdatePreferenceRequestImpl>
    implements _$$UpdatePreferenceRequestImplCopyWith<$Res> {
  __$$UpdatePreferenceRequestImplCopyWithImpl(
      _$UpdatePreferenceRequestImpl _value,
      $Res Function(_$UpdatePreferenceRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdatePreferenceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferenceText = null,
  }) {
    return _then(_$UpdatePreferenceRequestImpl(
      preferenceText: null == preferenceText
          ? _value.preferenceText
          : preferenceText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdatePreferenceRequestImpl implements _UpdatePreferenceRequest {
  const _$UpdatePreferenceRequestImpl(
      {@JsonKey(name: 'preference_text') required this.preferenceText});

  factory _$UpdatePreferenceRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdatePreferenceRequestImplFromJson(json);

  @override
  @JsonKey(name: 'preference_text')
  final String preferenceText;

  @override
  String toString() {
    return 'UpdatePreferenceRequest(preferenceText: $preferenceText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdatePreferenceRequestImpl &&
            (identical(other.preferenceText, preferenceText) ||
                other.preferenceText == preferenceText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, preferenceText);

  /// Create a copy of UpdatePreferenceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdatePreferenceRequestImplCopyWith<_$UpdatePreferenceRequestImpl>
      get copyWith => __$$UpdatePreferenceRequestImplCopyWithImpl<
          _$UpdatePreferenceRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdatePreferenceRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdatePreferenceRequest implements UpdatePreferenceRequest {
  const factory _UpdatePreferenceRequest(
      {@JsonKey(name: 'preference_text')
      required final String preferenceText}) = _$UpdatePreferenceRequestImpl;

  factory _UpdatePreferenceRequest.fromJson(Map<String, dynamic> json) =
      _$UpdatePreferenceRequestImpl.fromJson;

  @override
  @JsonKey(name: 'preference_text')
  String get preferenceText;

  /// Create a copy of UpdatePreferenceRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdatePreferenceRequestImplCopyWith<_$UpdatePreferenceRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdatePreferenceResponse _$UpdatePreferenceResponseFromJson(
    Map<String, dynamic> json) {
  return _UpdatePreferenceResponse.fromJson(json);
}

/// @nodoc
mixin _$UpdatePreferenceResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'safety_warning')
  String? get safetyWarning => throw _privateConstructorUsedError;

  /// Serializes this UpdatePreferenceResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdatePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdatePreferenceResponseCopyWith<UpdatePreferenceResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdatePreferenceResponseCopyWith<$Res> {
  factory $UpdatePreferenceResponseCopyWith(UpdatePreferenceResponse value,
          $Res Function(UpdatePreferenceResponse) then) =
      _$UpdatePreferenceResponseCopyWithImpl<$Res, UpdatePreferenceResponse>;
  @useResult
  $Res call(
      {bool success,
      String? message,
      @JsonKey(name: 'safety_warning') String? safetyWarning});
}

/// @nodoc
class _$UpdatePreferenceResponseCopyWithImpl<$Res,
        $Val extends UpdatePreferenceResponse>
    implements $UpdatePreferenceResponseCopyWith<$Res> {
  _$UpdatePreferenceResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdatePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? safetyWarning = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      safetyWarning: freezed == safetyWarning
          ? _value.safetyWarning
          : safetyWarning // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdatePreferenceResponseImplCopyWith<$Res>
    implements $UpdatePreferenceResponseCopyWith<$Res> {
  factory _$$UpdatePreferenceResponseImplCopyWith(
          _$UpdatePreferenceResponseImpl value,
          $Res Function(_$UpdatePreferenceResponseImpl) then) =
      __$$UpdatePreferenceResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String? message,
      @JsonKey(name: 'safety_warning') String? safetyWarning});
}

/// @nodoc
class __$$UpdatePreferenceResponseImplCopyWithImpl<$Res>
    extends _$UpdatePreferenceResponseCopyWithImpl<$Res,
        _$UpdatePreferenceResponseImpl>
    implements _$$UpdatePreferenceResponseImplCopyWith<$Res> {
  __$$UpdatePreferenceResponseImplCopyWithImpl(
      _$UpdatePreferenceResponseImpl _value,
      $Res Function(_$UpdatePreferenceResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdatePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? safetyWarning = freezed,
  }) {
    return _then(_$UpdatePreferenceResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      safetyWarning: freezed == safetyWarning
          ? _value.safetyWarning
          : safetyWarning // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdatePreferenceResponseImpl implements _UpdatePreferenceResponse {
  const _$UpdatePreferenceResponseImpl(
      {this.success = true,
      this.message,
      @JsonKey(name: 'safety_warning') this.safetyWarning});

  factory _$UpdatePreferenceResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdatePreferenceResponseImplFromJson(json);

  @override
  @JsonKey()
  final bool success;
  @override
  final String? message;
  @override
  @JsonKey(name: 'safety_warning')
  final String? safetyWarning;

  @override
  String toString() {
    return 'UpdatePreferenceResponse(success: $success, message: $message, safetyWarning: $safetyWarning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdatePreferenceResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.safetyWarning, safetyWarning) ||
                other.safetyWarning == safetyWarning));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, message, safetyWarning);

  /// Create a copy of UpdatePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdatePreferenceResponseImplCopyWith<_$UpdatePreferenceResponseImpl>
      get copyWith => __$$UpdatePreferenceResponseImplCopyWithImpl<
          _$UpdatePreferenceResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdatePreferenceResponseImplToJson(
      this,
    );
  }
}

abstract class _UpdatePreferenceResponse implements UpdatePreferenceResponse {
  const factory _UpdatePreferenceResponse(
          {final bool success,
          final String? message,
          @JsonKey(name: 'safety_warning') final String? safetyWarning}) =
      _$UpdatePreferenceResponseImpl;

  factory _UpdatePreferenceResponse.fromJson(Map<String, dynamic> json) =
      _$UpdatePreferenceResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get message;
  @override
  @JsonKey(name: 'safety_warning')
  String? get safetyWarning;

  /// Create a copy of UpdatePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdatePreferenceResponseImplCopyWith<_$UpdatePreferenceResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

DeletePreferenceResponse _$DeletePreferenceResponseFromJson(
    Map<String, dynamic> json) {
  return _DeletePreferenceResponse.fromJson(json);
}

/// @nodoc
mixin _$DeletePreferenceResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this DeletePreferenceResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeletePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeletePreferenceResponseCopyWith<DeletePreferenceResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeletePreferenceResponseCopyWith<$Res> {
  factory $DeletePreferenceResponseCopyWith(DeletePreferenceResponse value,
          $Res Function(DeletePreferenceResponse) then) =
      _$DeletePreferenceResponseCopyWithImpl<$Res, DeletePreferenceResponse>;
  @useResult
  $Res call({bool success, String? message});
}

/// @nodoc
class _$DeletePreferenceResponseCopyWithImpl<$Res,
        $Val extends DeletePreferenceResponse>
    implements $DeletePreferenceResponseCopyWith<$Res> {
  _$DeletePreferenceResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeletePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeletePreferenceResponseImplCopyWith<$Res>
    implements $DeletePreferenceResponseCopyWith<$Res> {
  factory _$$DeletePreferenceResponseImplCopyWith(
          _$DeletePreferenceResponseImpl value,
          $Res Function(_$DeletePreferenceResponseImpl) then) =
      __$$DeletePreferenceResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String? message});
}

/// @nodoc
class __$$DeletePreferenceResponseImplCopyWithImpl<$Res>
    extends _$DeletePreferenceResponseCopyWithImpl<$Res,
        _$DeletePreferenceResponseImpl>
    implements _$$DeletePreferenceResponseImplCopyWith<$Res> {
  __$$DeletePreferenceResponseImplCopyWithImpl(
      _$DeletePreferenceResponseImpl _value,
      $Res Function(_$DeletePreferenceResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeletePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
  }) {
    return _then(_$DeletePreferenceResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeletePreferenceResponseImpl implements _DeletePreferenceResponse {
  const _$DeletePreferenceResponseImpl({this.success = true, this.message});

  factory _$DeletePreferenceResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeletePreferenceResponseImplFromJson(json);

  @override
  @JsonKey()
  final bool success;
  @override
  final String? message;

  @override
  String toString() {
    return 'DeletePreferenceResponse(success: $success, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeletePreferenceResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, message);

  /// Create a copy of DeletePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeletePreferenceResponseImplCopyWith<_$DeletePreferenceResponseImpl>
      get copyWith => __$$DeletePreferenceResponseImplCopyWithImpl<
          _$DeletePreferenceResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeletePreferenceResponseImplToJson(
      this,
    );
  }
}

abstract class _DeletePreferenceResponse implements DeletePreferenceResponse {
  const factory _DeletePreferenceResponse(
      {final bool success,
      final String? message}) = _$DeletePreferenceResponseImpl;

  factory _DeletePreferenceResponse.fromJson(Map<String, dynamic> json) =
      _$DeletePreferenceResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get message;

  /// Create a copy of DeletePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeletePreferenceResponseImplCopyWith<_$DeletePreferenceResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ApiErrorDetail _$ApiErrorDetailFromJson(Map<String, dynamic> json) {
  return _ApiErrorDetail.fromJson(json);
}

/// @nodoc
mixin _$ApiErrorDetail {
  String get code => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this ApiErrorDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiErrorDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiErrorDetailCopyWith<ApiErrorDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiErrorDetailCopyWith<$Res> {
  factory $ApiErrorDetailCopyWith(
          ApiErrorDetail value, $Res Function(ApiErrorDetail) then) =
      _$ApiErrorDetailCopyWithImpl<$Res, ApiErrorDetail>;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class _$ApiErrorDetailCopyWithImpl<$Res, $Val extends ApiErrorDetail>
    implements $ApiErrorDetailCopyWith<$Res> {
  _$ApiErrorDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiErrorDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiErrorDetailImplCopyWith<$Res>
    implements $ApiErrorDetailCopyWith<$Res> {
  factory _$$ApiErrorDetailImplCopyWith(_$ApiErrorDetailImpl value,
          $Res Function(_$ApiErrorDetailImpl) then) =
      __$$ApiErrorDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class __$$ApiErrorDetailImplCopyWithImpl<$Res>
    extends _$ApiErrorDetailCopyWithImpl<$Res, _$ApiErrorDetailImpl>
    implements _$$ApiErrorDetailImplCopyWith<$Res> {
  __$$ApiErrorDetailImplCopyWithImpl(
      _$ApiErrorDetailImpl _value, $Res Function(_$ApiErrorDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiErrorDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_$ApiErrorDetailImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiErrorDetailImpl implements _ApiErrorDetail {
  const _$ApiErrorDetailImpl(
      {this.code = 'UNKNOWN_ERROR',
      this.message = 'An unknown error occurred'});

  factory _$ApiErrorDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiErrorDetailImplFromJson(json);

  @override
  @JsonKey()
  final String code;
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'ApiErrorDetail(code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiErrorDetailImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  /// Create a copy of ApiErrorDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiErrorDetailImplCopyWith<_$ApiErrorDetailImpl> get copyWith =>
      __$$ApiErrorDetailImplCopyWithImpl<_$ApiErrorDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiErrorDetailImplToJson(
      this,
    );
  }
}

abstract class _ApiErrorDetail implements ApiErrorDetail {
  const factory _ApiErrorDetail({final String code, final String message}) =
      _$ApiErrorDetailImpl;

  factory _ApiErrorDetail.fromJson(Map<String, dynamic> json) =
      _$ApiErrorDetailImpl.fromJson;

  @override
  String get code;
  @override
  String get message;

  /// Create a copy of ApiErrorDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiErrorDetailImplCopyWith<_$ApiErrorDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiErrorResponse _$ApiErrorResponseFromJson(Map<String, dynamic> json) {
  return _ApiErrorResponse.fromJson(json);
}

/// @nodoc
mixin _$ApiErrorResponse {
  ApiErrorDetail get error => throw _privateConstructorUsedError;

  /// Serializes this ApiErrorResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiErrorResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiErrorResponseCopyWith<ApiErrorResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiErrorResponseCopyWith<$Res> {
  factory $ApiErrorResponseCopyWith(
          ApiErrorResponse value, $Res Function(ApiErrorResponse) then) =
      _$ApiErrorResponseCopyWithImpl<$Res, ApiErrorResponse>;
  @useResult
  $Res call({ApiErrorDetail error});

  $ApiErrorDetailCopyWith<$Res> get error;
}

/// @nodoc
class _$ApiErrorResponseCopyWithImpl<$Res, $Val extends ApiErrorResponse>
    implements $ApiErrorResponseCopyWith<$Res> {
  _$ApiErrorResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiErrorResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_value.copyWith(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as ApiErrorDetail,
    ) as $Val);
  }

  /// Create a copy of ApiErrorResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiErrorDetailCopyWith<$Res> get error {
    return $ApiErrorDetailCopyWith<$Res>(_value.error, (value) {
      return _then(_value.copyWith(error: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApiErrorResponseImplCopyWith<$Res>
    implements $ApiErrorResponseCopyWith<$Res> {
  factory _$$ApiErrorResponseImplCopyWith(_$ApiErrorResponseImpl value,
          $Res Function(_$ApiErrorResponseImpl) then) =
      __$$ApiErrorResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ApiErrorDetail error});

  @override
  $ApiErrorDetailCopyWith<$Res> get error;
}

/// @nodoc
class __$$ApiErrorResponseImplCopyWithImpl<$Res>
    extends _$ApiErrorResponseCopyWithImpl<$Res, _$ApiErrorResponseImpl>
    implements _$$ApiErrorResponseImplCopyWith<$Res> {
  __$$ApiErrorResponseImplCopyWithImpl(_$ApiErrorResponseImpl _value,
      $Res Function(_$ApiErrorResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiErrorResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$ApiErrorResponseImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as ApiErrorDetail,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiErrorResponseImpl extends _ApiErrorResponse {
  const _$ApiErrorResponseImpl({required this.error}) : super._();

  factory _$ApiErrorResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiErrorResponseImplFromJson(json);

  @override
  final ApiErrorDetail error;

  @override
  String toString() {
    return 'ApiErrorResponse(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiErrorResponseImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of ApiErrorResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiErrorResponseImplCopyWith<_$ApiErrorResponseImpl> get copyWith =>
      __$$ApiErrorResponseImplCopyWithImpl<_$ApiErrorResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiErrorResponseImplToJson(
      this,
    );
  }
}

abstract class _ApiErrorResponse extends ApiErrorResponse {
  const factory _ApiErrorResponse({required final ApiErrorDetail error}) =
      _$ApiErrorResponseImpl;
  const _ApiErrorResponse._() : super._();

  factory _ApiErrorResponse.fromJson(Map<String, dynamic> json) =
      _$ApiErrorResponseImpl.fromJson;

  @override
  ApiErrorDetail get error;

  /// Create a copy of ApiErrorResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiErrorResponseImplCopyWith<_$ApiErrorResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
