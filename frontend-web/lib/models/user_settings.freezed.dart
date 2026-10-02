// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ModelSettings _$ModelSettingsFromJson(Map<String, dynamic> json) {
  return _ModelSettings.fromJson(json);
}

/// @nodoc
mixin _$ModelSettings {
  @JsonKey(name: 'base_impression')
  String get baseImpression => throw _privateConstructorUsedError;
  @JsonKey(name: 'style_refinement')
  String get styleRefinement => throw _privateConstructorUsedError;
  @JsonKey(name: 'preference_inference')
  String get preferenceInference => throw _privateConstructorUsedError;
  @JsonKey(name: 'preference_validator')
  String get preferenceValidator => throw _privateConstructorUsedError;
  @JsonKey(name: 'preference_edit_validator')
  String get preferenceEditValidator => throw _privateConstructorUsedError;

  /// Serializes this ModelSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ModelSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModelSettingsCopyWith<ModelSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModelSettingsCopyWith<$Res> {
  factory $ModelSettingsCopyWith(
    ModelSettings value,
    $Res Function(ModelSettings) then,
  ) = _$ModelSettingsCopyWithImpl<$Res, ModelSettings>;
  @useResult
  $Res call({
    @JsonKey(name: 'base_impression') String baseImpression,
    @JsonKey(name: 'style_refinement') String styleRefinement,
    @JsonKey(name: 'preference_inference') String preferenceInference,
    @JsonKey(name: 'preference_validator') String preferenceValidator,
    @JsonKey(name: 'preference_edit_validator') String preferenceEditValidator,
  });
}

/// @nodoc
class _$ModelSettingsCopyWithImpl<$Res, $Val extends ModelSettings>
    implements $ModelSettingsCopyWith<$Res> {
  _$ModelSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModelSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseImpression = null,
    Object? styleRefinement = null,
    Object? preferenceInference = null,
    Object? preferenceValidator = null,
    Object? preferenceEditValidator = null,
  }) {
    return _then(
      _value.copyWith(
            baseImpression: null == baseImpression
                ? _value.baseImpression
                : baseImpression // ignore: cast_nullable_to_non_nullable
                      as String,
            styleRefinement: null == styleRefinement
                ? _value.styleRefinement
                : styleRefinement // ignore: cast_nullable_to_non_nullable
                      as String,
            preferenceInference: null == preferenceInference
                ? _value.preferenceInference
                : preferenceInference // ignore: cast_nullable_to_non_nullable
                      as String,
            preferenceValidator: null == preferenceValidator
                ? _value.preferenceValidator
                : preferenceValidator // ignore: cast_nullable_to_non_nullable
                      as String,
            preferenceEditValidator: null == preferenceEditValidator
                ? _value.preferenceEditValidator
                : preferenceEditValidator // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ModelSettingsImplCopyWith<$Res>
    implements $ModelSettingsCopyWith<$Res> {
  factory _$$ModelSettingsImplCopyWith(
    _$ModelSettingsImpl value,
    $Res Function(_$ModelSettingsImpl) then,
  ) = __$$ModelSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'base_impression') String baseImpression,
    @JsonKey(name: 'style_refinement') String styleRefinement,
    @JsonKey(name: 'preference_inference') String preferenceInference,
    @JsonKey(name: 'preference_validator') String preferenceValidator,
    @JsonKey(name: 'preference_edit_validator') String preferenceEditValidator,
  });
}

/// @nodoc
class __$$ModelSettingsImplCopyWithImpl<$Res>
    extends _$ModelSettingsCopyWithImpl<$Res, _$ModelSettingsImpl>
    implements _$$ModelSettingsImplCopyWith<$Res> {
  __$$ModelSettingsImplCopyWithImpl(
    _$ModelSettingsImpl _value,
    $Res Function(_$ModelSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ModelSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseImpression = null,
    Object? styleRefinement = null,
    Object? preferenceInference = null,
    Object? preferenceValidator = null,
    Object? preferenceEditValidator = null,
  }) {
    return _then(
      _$ModelSettingsImpl(
        baseImpression: null == baseImpression
            ? _value.baseImpression
            : baseImpression // ignore: cast_nullable_to_non_nullable
                  as String,
        styleRefinement: null == styleRefinement
            ? _value.styleRefinement
            : styleRefinement // ignore: cast_nullable_to_non_nullable
                  as String,
        preferenceInference: null == preferenceInference
            ? _value.preferenceInference
            : preferenceInference // ignore: cast_nullable_to_non_nullable
                  as String,
        preferenceValidator: null == preferenceValidator
            ? _value.preferenceValidator
            : preferenceValidator // ignore: cast_nullable_to_non_nullable
                  as String,
        preferenceEditValidator: null == preferenceEditValidator
            ? _value.preferenceEditValidator
            : preferenceEditValidator // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ModelSettingsImpl implements _ModelSettings {
  const _$ModelSettingsImpl({
    @JsonKey(name: 'base_impression') this.baseImpression = 'sonnet',
    @JsonKey(name: 'style_refinement') this.styleRefinement = 'sonnet',
    @JsonKey(name: 'preference_inference') this.preferenceInference = 'sonnet',
    @JsonKey(name: 'preference_validator') this.preferenceValidator = 'haiku',
    @JsonKey(name: 'preference_edit_validator')
    this.preferenceEditValidator = 'haiku',
  });

  factory _$ModelSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModelSettingsImplFromJson(json);

  @override
  @JsonKey(name: 'base_impression')
  final String baseImpression;
  @override
  @JsonKey(name: 'style_refinement')
  final String styleRefinement;
  @override
  @JsonKey(name: 'preference_inference')
  final String preferenceInference;
  @override
  @JsonKey(name: 'preference_validator')
  final String preferenceValidator;
  @override
  @JsonKey(name: 'preference_edit_validator')
  final String preferenceEditValidator;

  @override
  String toString() {
    return 'ModelSettings(baseImpression: $baseImpression, styleRefinement: $styleRefinement, preferenceInference: $preferenceInference, preferenceValidator: $preferenceValidator, preferenceEditValidator: $preferenceEditValidator)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModelSettingsImpl &&
            (identical(other.baseImpression, baseImpression) ||
                other.baseImpression == baseImpression) &&
            (identical(other.styleRefinement, styleRefinement) ||
                other.styleRefinement == styleRefinement) &&
            (identical(other.preferenceInference, preferenceInference) ||
                other.preferenceInference == preferenceInference) &&
            (identical(other.preferenceValidator, preferenceValidator) ||
                other.preferenceValidator == preferenceValidator) &&
            (identical(
                  other.preferenceEditValidator,
                  preferenceEditValidator,
                ) ||
                other.preferenceEditValidator == preferenceEditValidator));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    baseImpression,
    styleRefinement,
    preferenceInference,
    preferenceValidator,
    preferenceEditValidator,
  );

  /// Create a copy of ModelSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModelSettingsImplCopyWith<_$ModelSettingsImpl> get copyWith =>
      __$$ModelSettingsImplCopyWithImpl<_$ModelSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModelSettingsImplToJson(this);
  }
}

abstract class _ModelSettings implements ModelSettings {
  const factory _ModelSettings({
    @JsonKey(name: 'base_impression') final String baseImpression,
    @JsonKey(name: 'style_refinement') final String styleRefinement,
    @JsonKey(name: 'preference_inference') final String preferenceInference,
    @JsonKey(name: 'preference_validator') final String preferenceValidator,
    @JsonKey(name: 'preference_edit_validator')
    final String preferenceEditValidator,
  }) = _$ModelSettingsImpl;

  factory _ModelSettings.fromJson(Map<String, dynamic> json) =
      _$ModelSettingsImpl.fromJson;

  @override
  @JsonKey(name: 'base_impression')
  String get baseImpression;
  @override
  @JsonKey(name: 'style_refinement')
  String get styleRefinement;
  @override
  @JsonKey(name: 'preference_inference')
  String get preferenceInference;
  @override
  @JsonKey(name: 'preference_validator')
  String get preferenceValidator;
  @override
  @JsonKey(name: 'preference_edit_validator')
  String get preferenceEditValidator;

  /// Create a copy of ModelSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModelSettingsImplCopyWith<_$ModelSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) {
  return _UserSettings.fromJson(json);
}

/// @nodoc
mixin _$UserSettings {
  @JsonKey(name: 'clinical_interpretation')
  bool get clinicalInterpretation => throw _privateConstructorUsedError;
  @JsonKey(name: 'model_settings')
  ModelSettings get modelSettings => throw _privateConstructorUsedError;
  @JsonKey(name: 'k_preferences')
  int get kPreferences => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_source')
  String get dataSource => throw _privateConstructorUsedError;
  @JsonKey(name: 'mimic_bucket')
  String? get mimicBucket => throw _privateConstructorUsedError;

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
    UserSettings value,
    $Res Function(UserSettings) then,
  ) = _$UserSettingsCopyWithImpl<$Res, UserSettings>;
  @useResult
  $Res call({
    @JsonKey(name: 'clinical_interpretation') bool clinicalInterpretation,
    @JsonKey(name: 'model_settings') ModelSettings modelSettings,
    @JsonKey(name: 'k_preferences') int kPreferences,
    @JsonKey(name: 'data_source') String dataSource,
    @JsonKey(name: 'mimic_bucket') String? mimicBucket,
  });

  $ModelSettingsCopyWith<$Res> get modelSettings;
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res, $Val extends UserSettings>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clinicalInterpretation = null,
    Object? modelSettings = null,
    Object? kPreferences = null,
    Object? dataSource = null,
    Object? mimicBucket = freezed,
  }) {
    return _then(
      _value.copyWith(
            clinicalInterpretation: null == clinicalInterpretation
                ? _value.clinicalInterpretation
                : clinicalInterpretation // ignore: cast_nullable_to_non_nullable
                      as bool,
            modelSettings: null == modelSettings
                ? _value.modelSettings
                : modelSettings // ignore: cast_nullable_to_non_nullable
                      as ModelSettings,
            kPreferences: null == kPreferences
                ? _value.kPreferences
                : kPreferences // ignore: cast_nullable_to_non_nullable
                      as int,
            dataSource: null == dataSource
                ? _value.dataSource
                : dataSource // ignore: cast_nullable_to_non_nullable
                      as String,
            mimicBucket: freezed == mimicBucket
                ? _value.mimicBucket
                : mimicBucket // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ModelSettingsCopyWith<$Res> get modelSettings {
    return $ModelSettingsCopyWith<$Res>(_value.modelSettings, (value) {
      return _then(_value.copyWith(modelSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserSettingsImplCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$$UserSettingsImplCopyWith(
    _$UserSettingsImpl value,
    $Res Function(_$UserSettingsImpl) then,
  ) = __$$UserSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'clinical_interpretation') bool clinicalInterpretation,
    @JsonKey(name: 'model_settings') ModelSettings modelSettings,
    @JsonKey(name: 'k_preferences') int kPreferences,
    @JsonKey(name: 'data_source') String dataSource,
    @JsonKey(name: 'mimic_bucket') String? mimicBucket,
  });

  @override
  $ModelSettingsCopyWith<$Res> get modelSettings;
}

/// @nodoc
class __$$UserSettingsImplCopyWithImpl<$Res>
    extends _$UserSettingsCopyWithImpl<$Res, _$UserSettingsImpl>
    implements _$$UserSettingsImplCopyWith<$Res> {
  __$$UserSettingsImplCopyWithImpl(
    _$UserSettingsImpl _value,
    $Res Function(_$UserSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clinicalInterpretation = null,
    Object? modelSettings = null,
    Object? kPreferences = null,
    Object? dataSource = null,
    Object? mimicBucket = freezed,
  }) {
    return _then(
      _$UserSettingsImpl(
        clinicalInterpretation: null == clinicalInterpretation
            ? _value.clinicalInterpretation
            : clinicalInterpretation // ignore: cast_nullable_to_non_nullable
                  as bool,
        modelSettings: null == modelSettings
            ? _value.modelSettings
            : modelSettings // ignore: cast_nullable_to_non_nullable
                  as ModelSettings,
        kPreferences: null == kPreferences
            ? _value.kPreferences
            : kPreferences // ignore: cast_nullable_to_non_nullable
                  as int,
        dataSource: null == dataSource
            ? _value.dataSource
            : dataSource // ignore: cast_nullable_to_non_nullable
                  as String,
        mimicBucket: freezed == mimicBucket
            ? _value.mimicBucket
            : mimicBucket // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSettingsImpl implements _UserSettings {
  const _$UserSettingsImpl({
    @JsonKey(name: 'clinical_interpretation')
    this.clinicalInterpretation = true,
    @JsonKey(name: 'model_settings') this.modelSettings = const ModelSettings(),
    @JsonKey(name: 'k_preferences') this.kPreferences = 10,
    @JsonKey(name: 'data_source') this.dataSource = 'synthetic',
    @JsonKey(name: 'mimic_bucket') this.mimicBucket,
  });

  factory _$UserSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsImplFromJson(json);

  @override
  @JsonKey(name: 'clinical_interpretation')
  final bool clinicalInterpretation;
  @override
  @JsonKey(name: 'model_settings')
  final ModelSettings modelSettings;
  @override
  @JsonKey(name: 'k_preferences')
  final int kPreferences;
  @override
  @JsonKey(name: 'data_source')
  final String dataSource;
  @override
  @JsonKey(name: 'mimic_bucket')
  final String? mimicBucket;

  @override
  String toString() {
    return 'UserSettings(clinicalInterpretation: $clinicalInterpretation, modelSettings: $modelSettings, kPreferences: $kPreferences, dataSource: $dataSource, mimicBucket: $mimicBucket)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsImpl &&
            (identical(other.clinicalInterpretation, clinicalInterpretation) ||
                other.clinicalInterpretation == clinicalInterpretation) &&
            (identical(other.modelSettings, modelSettings) ||
                other.modelSettings == modelSettings) &&
            (identical(other.kPreferences, kPreferences) ||
                other.kPreferences == kPreferences) &&
            (identical(other.dataSource, dataSource) ||
                other.dataSource == dataSource) &&
            (identical(other.mimicBucket, mimicBucket) ||
                other.mimicBucket == mimicBucket));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    clinicalInterpretation,
    modelSettings,
    kPreferences,
    dataSource,
    mimicBucket,
  );

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      __$$UserSettingsImplCopyWithImpl<_$UserSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSettingsImplToJson(this);
  }
}

abstract class _UserSettings implements UserSettings {
  const factory _UserSettings({
    @JsonKey(name: 'clinical_interpretation') final bool clinicalInterpretation,
    @JsonKey(name: 'model_settings') final ModelSettings modelSettings,
    @JsonKey(name: 'k_preferences') final int kPreferences,
    @JsonKey(name: 'data_source') final String dataSource,
    @JsonKey(name: 'mimic_bucket') final String? mimicBucket,
  }) = _$UserSettingsImpl;

  factory _UserSettings.fromJson(Map<String, dynamic> json) =
      _$UserSettingsImpl.fromJson;

  @override
  @JsonKey(name: 'clinical_interpretation')
  bool get clinicalInterpretation;
  @override
  @JsonKey(name: 'model_settings')
  ModelSettings get modelSettings;
  @override
  @JsonKey(name: 'k_preferences')
  int get kPreferences;
  @override
  @JsonKey(name: 'data_source')
  String get dataSource;
  @override
  @JsonKey(name: 'mimic_bucket')
  String? get mimicBucket;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateSettingsRequest _$UpdateSettingsRequestFromJson(
  Map<String, dynamic> json,
) {
  return _UpdateSettingsRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateSettingsRequest {
  @JsonKey(name: 'clinical_interpretation')
  bool? get clinicalInterpretation => throw _privateConstructorUsedError;
  @JsonKey(name: 'model_settings')
  ModelSettings? get modelSettings => throw _privateConstructorUsedError;
  @JsonKey(name: 'k_preferences')
  int? get kPreferences => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_source')
  String? get dataSource => throw _privateConstructorUsedError;
  @JsonKey(name: 'mimic_bucket')
  String? get mimicBucket => throw _privateConstructorUsedError;

  /// Serializes this UpdateSettingsRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateSettingsRequestCopyWith<UpdateSettingsRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateSettingsRequestCopyWith<$Res> {
  factory $UpdateSettingsRequestCopyWith(
    UpdateSettingsRequest value,
    $Res Function(UpdateSettingsRequest) then,
  ) = _$UpdateSettingsRequestCopyWithImpl<$Res, UpdateSettingsRequest>;
  @useResult
  $Res call({
    @JsonKey(name: 'clinical_interpretation') bool? clinicalInterpretation,
    @JsonKey(name: 'model_settings') ModelSettings? modelSettings,
    @JsonKey(name: 'k_preferences') int? kPreferences,
    @JsonKey(name: 'data_source') String? dataSource,
    @JsonKey(name: 'mimic_bucket') String? mimicBucket,
  });

  $ModelSettingsCopyWith<$Res>? get modelSettings;
}

/// @nodoc
class _$UpdateSettingsRequestCopyWithImpl<
  $Res,
  $Val extends UpdateSettingsRequest
>
    implements $UpdateSettingsRequestCopyWith<$Res> {
  _$UpdateSettingsRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clinicalInterpretation = freezed,
    Object? modelSettings = freezed,
    Object? kPreferences = freezed,
    Object? dataSource = freezed,
    Object? mimicBucket = freezed,
  }) {
    return _then(
      _value.copyWith(
            clinicalInterpretation: freezed == clinicalInterpretation
                ? _value.clinicalInterpretation
                : clinicalInterpretation // ignore: cast_nullable_to_non_nullable
                      as bool?,
            modelSettings: freezed == modelSettings
                ? _value.modelSettings
                : modelSettings // ignore: cast_nullable_to_non_nullable
                      as ModelSettings?,
            kPreferences: freezed == kPreferences
                ? _value.kPreferences
                : kPreferences // ignore: cast_nullable_to_non_nullable
                      as int?,
            dataSource: freezed == dataSource
                ? _value.dataSource
                : dataSource // ignore: cast_nullable_to_non_nullable
                      as String?,
            mimicBucket: freezed == mimicBucket
                ? _value.mimicBucket
                : mimicBucket // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of UpdateSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ModelSettingsCopyWith<$Res>? get modelSettings {
    if (_value.modelSettings == null) {
      return null;
    }

    return $ModelSettingsCopyWith<$Res>(_value.modelSettings!, (value) {
      return _then(_value.copyWith(modelSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UpdateSettingsRequestImplCopyWith<$Res>
    implements $UpdateSettingsRequestCopyWith<$Res> {
  factory _$$UpdateSettingsRequestImplCopyWith(
    _$UpdateSettingsRequestImpl value,
    $Res Function(_$UpdateSettingsRequestImpl) then,
  ) = __$$UpdateSettingsRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'clinical_interpretation') bool? clinicalInterpretation,
    @JsonKey(name: 'model_settings') ModelSettings? modelSettings,
    @JsonKey(name: 'k_preferences') int? kPreferences,
    @JsonKey(name: 'data_source') String? dataSource,
    @JsonKey(name: 'mimic_bucket') String? mimicBucket,
  });

  @override
  $ModelSettingsCopyWith<$Res>? get modelSettings;
}

/// @nodoc
class __$$UpdateSettingsRequestImplCopyWithImpl<$Res>
    extends
        _$UpdateSettingsRequestCopyWithImpl<$Res, _$UpdateSettingsRequestImpl>
    implements _$$UpdateSettingsRequestImplCopyWith<$Res> {
  __$$UpdateSettingsRequestImplCopyWithImpl(
    _$UpdateSettingsRequestImpl _value,
    $Res Function(_$UpdateSettingsRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clinicalInterpretation = freezed,
    Object? modelSettings = freezed,
    Object? kPreferences = freezed,
    Object? dataSource = freezed,
    Object? mimicBucket = freezed,
  }) {
    return _then(
      _$UpdateSettingsRequestImpl(
        clinicalInterpretation: freezed == clinicalInterpretation
            ? _value.clinicalInterpretation
            : clinicalInterpretation // ignore: cast_nullable_to_non_nullable
                  as bool?,
        modelSettings: freezed == modelSettings
            ? _value.modelSettings
            : modelSettings // ignore: cast_nullable_to_non_nullable
                  as ModelSettings?,
        kPreferences: freezed == kPreferences
            ? _value.kPreferences
            : kPreferences // ignore: cast_nullable_to_non_nullable
                  as int?,
        dataSource: freezed == dataSource
            ? _value.dataSource
            : dataSource // ignore: cast_nullable_to_non_nullable
                  as String?,
        mimicBucket: freezed == mimicBucket
            ? _value.mimicBucket
            : mimicBucket // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _$UpdateSettingsRequestImpl implements _UpdateSettingsRequest {
  const _$UpdateSettingsRequestImpl({
    @JsonKey(name: 'clinical_interpretation') this.clinicalInterpretation,
    @JsonKey(name: 'model_settings') this.modelSettings,
    @JsonKey(name: 'k_preferences') this.kPreferences,
    @JsonKey(name: 'data_source') this.dataSource,
    @JsonKey(name: 'mimic_bucket') this.mimicBucket,
  });

  factory _$UpdateSettingsRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateSettingsRequestImplFromJson(json);

  @override
  @JsonKey(name: 'clinical_interpretation')
  final bool? clinicalInterpretation;
  @override
  @JsonKey(name: 'model_settings')
  final ModelSettings? modelSettings;
  @override
  @JsonKey(name: 'k_preferences')
  final int? kPreferences;
  @override
  @JsonKey(name: 'data_source')
  final String? dataSource;
  @override
  @JsonKey(name: 'mimic_bucket')
  final String? mimicBucket;

  @override
  String toString() {
    return 'UpdateSettingsRequest(clinicalInterpretation: $clinicalInterpretation, modelSettings: $modelSettings, kPreferences: $kPreferences, dataSource: $dataSource, mimicBucket: $mimicBucket)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateSettingsRequestImpl &&
            (identical(other.clinicalInterpretation, clinicalInterpretation) ||
                other.clinicalInterpretation == clinicalInterpretation) &&
            (identical(other.modelSettings, modelSettings) ||
                other.modelSettings == modelSettings) &&
            (identical(other.kPreferences, kPreferences) ||
                other.kPreferences == kPreferences) &&
            (identical(other.dataSource, dataSource) ||
                other.dataSource == dataSource) &&
            (identical(other.mimicBucket, mimicBucket) ||
                other.mimicBucket == mimicBucket));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    clinicalInterpretation,
    modelSettings,
    kPreferences,
    dataSource,
    mimicBucket,
  );

  /// Create a copy of UpdateSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateSettingsRequestImplCopyWith<_$UpdateSettingsRequestImpl>
  get copyWith =>
      __$$UpdateSettingsRequestImplCopyWithImpl<_$UpdateSettingsRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateSettingsRequestImplToJson(this);
  }
}

abstract class _UpdateSettingsRequest implements UpdateSettingsRequest {
  const factory _UpdateSettingsRequest({
    @JsonKey(name: 'clinical_interpretation')
    final bool? clinicalInterpretation,
    @JsonKey(name: 'model_settings') final ModelSettings? modelSettings,
    @JsonKey(name: 'k_preferences') final int? kPreferences,
    @JsonKey(name: 'data_source') final String? dataSource,
    @JsonKey(name: 'mimic_bucket') final String? mimicBucket,
  }) = _$UpdateSettingsRequestImpl;

  factory _UpdateSettingsRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateSettingsRequestImpl.fromJson;

  @override
  @JsonKey(name: 'clinical_interpretation')
  bool? get clinicalInterpretation;
  @override
  @JsonKey(name: 'model_settings')
  ModelSettings? get modelSettings;
  @override
  @JsonKey(name: 'k_preferences')
  int? get kPreferences;
  @override
  @JsonKey(name: 'data_source')
  String? get dataSource;
  @override
  @JsonKey(name: 'mimic_bucket')
  String? get mimicBucket;

  /// Create a copy of UpdateSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateSettingsRequestImplCopyWith<_$UpdateSettingsRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

UpdateSettingsResponse _$UpdateSettingsResponseFromJson(
  Map<String, dynamic> json,
) {
  return _UpdateSettingsResponse.fromJson(json);
}

/// @nodoc
mixin _$UpdateSettingsResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_reset')
  bool? get dataReset => throw _privateConstructorUsedError;
  @JsonKey(name: 'cases_loaded')
  int? get casesLoaded => throw _privateConstructorUsedError;

  /// Serializes this UpdateSettingsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateSettingsResponseCopyWith<UpdateSettingsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateSettingsResponseCopyWith<$Res> {
  factory $UpdateSettingsResponseCopyWith(
    UpdateSettingsResponse value,
    $Res Function(UpdateSettingsResponse) then,
  ) = _$UpdateSettingsResponseCopyWithImpl<$Res, UpdateSettingsResponse>;
  @useResult
  $Res call({
    bool success,
    String? message,
    @JsonKey(name: 'data_reset') bool? dataReset,
    @JsonKey(name: 'cases_loaded') int? casesLoaded,
  });
}

/// @nodoc
class _$UpdateSettingsResponseCopyWithImpl<
  $Res,
  $Val extends UpdateSettingsResponse
>
    implements $UpdateSettingsResponseCopyWith<$Res> {
  _$UpdateSettingsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? dataReset = freezed,
    Object? casesLoaded = freezed,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            dataReset: freezed == dataReset
                ? _value.dataReset
                : dataReset // ignore: cast_nullable_to_non_nullable
                      as bool?,
            casesLoaded: freezed == casesLoaded
                ? _value.casesLoaded
                : casesLoaded // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateSettingsResponseImplCopyWith<$Res>
    implements $UpdateSettingsResponseCopyWith<$Res> {
  factory _$$UpdateSettingsResponseImplCopyWith(
    _$UpdateSettingsResponseImpl value,
    $Res Function(_$UpdateSettingsResponseImpl) then,
  ) = __$$UpdateSettingsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    String? message,
    @JsonKey(name: 'data_reset') bool? dataReset,
    @JsonKey(name: 'cases_loaded') int? casesLoaded,
  });
}

/// @nodoc
class __$$UpdateSettingsResponseImplCopyWithImpl<$Res>
    extends
        _$UpdateSettingsResponseCopyWithImpl<$Res, _$UpdateSettingsResponseImpl>
    implements _$$UpdateSettingsResponseImplCopyWith<$Res> {
  __$$UpdateSettingsResponseImplCopyWithImpl(
    _$UpdateSettingsResponseImpl _value,
    $Res Function(_$UpdateSettingsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? dataReset = freezed,
    Object? casesLoaded = freezed,
  }) {
    return _then(
      _$UpdateSettingsResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        dataReset: freezed == dataReset
            ? _value.dataReset
            : dataReset // ignore: cast_nullable_to_non_nullable
                  as bool?,
        casesLoaded: freezed == casesLoaded
            ? _value.casesLoaded
            : casesLoaded // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateSettingsResponseImpl implements _UpdateSettingsResponse {
  const _$UpdateSettingsResponseImpl({
    this.success = true,
    this.message,
    @JsonKey(name: 'data_reset') this.dataReset,
    @JsonKey(name: 'cases_loaded') this.casesLoaded,
  });

  factory _$UpdateSettingsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateSettingsResponseImplFromJson(json);

  @override
  @JsonKey()
  final bool success;
  @override
  final String? message;
  @override
  @JsonKey(name: 'data_reset')
  final bool? dataReset;
  @override
  @JsonKey(name: 'cases_loaded')
  final int? casesLoaded;

  @override
  String toString() {
    return 'UpdateSettingsResponse(success: $success, message: $message, dataReset: $dataReset, casesLoaded: $casesLoaded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateSettingsResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.dataReset, dataReset) ||
                other.dataReset == dataReset) &&
            (identical(other.casesLoaded, casesLoaded) ||
                other.casesLoaded == casesLoaded));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, success, message, dataReset, casesLoaded);

  /// Create a copy of UpdateSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateSettingsResponseImplCopyWith<_$UpdateSettingsResponseImpl>
  get copyWith =>
      __$$UpdateSettingsResponseImplCopyWithImpl<_$UpdateSettingsResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateSettingsResponseImplToJson(this);
  }
}

abstract class _UpdateSettingsResponse implements UpdateSettingsResponse {
  const factory _UpdateSettingsResponse({
    final bool success,
    final String? message,
    @JsonKey(name: 'data_reset') final bool? dataReset,
    @JsonKey(name: 'cases_loaded') final int? casesLoaded,
  }) = _$UpdateSettingsResponseImpl;

  factory _UpdateSettingsResponse.fromJson(Map<String, dynamic> json) =
      _$UpdateSettingsResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get message;
  @override
  @JsonKey(name: 'data_reset')
  bool? get dataReset;
  @override
  @JsonKey(name: 'cases_loaded')
  int? get casesLoaded;

  /// Create a copy of UpdateSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateSettingsResponseImplCopyWith<_$UpdateSettingsResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
