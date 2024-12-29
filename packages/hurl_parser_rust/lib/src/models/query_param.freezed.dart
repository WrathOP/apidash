// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QueryParam _$QueryParamFromJson(Map<String, dynamic> json) {
  return _QueryParam.fromJson(json);
}

/// @nodoc
mixin _$QueryParam {
  String get name => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  /// Serializes this QueryParam to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QueryParam
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QueryParamCopyWith<QueryParam> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueryParamCopyWith<$Res> {
  factory $QueryParamCopyWith(
          QueryParam value, $Res Function(QueryParam) then) =
      _$QueryParamCopyWithImpl<$Res, QueryParam>;
  @useResult
  $Res call({String name, String value});
}

/// @nodoc
class _$QueryParamCopyWithImpl<$Res, $Val extends QueryParam>
    implements $QueryParamCopyWith<$Res> {
  _$QueryParamCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QueryParam
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QueryParamImplCopyWith<$Res>
    implements $QueryParamCopyWith<$Res> {
  factory _$$QueryParamImplCopyWith(
          _$QueryParamImpl value, $Res Function(_$QueryParamImpl) then) =
      __$$QueryParamImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String value});
}

/// @nodoc
class __$$QueryParamImplCopyWithImpl<$Res>
    extends _$QueryParamCopyWithImpl<$Res, _$QueryParamImpl>
    implements _$$QueryParamImplCopyWith<$Res> {
  __$$QueryParamImplCopyWithImpl(
      _$QueryParamImpl _value, $Res Function(_$QueryParamImpl) _then)
      : super(_value, _then);

  /// Create a copy of QueryParam
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
  }) {
    return _then(_$QueryParamImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QueryParamImpl implements _QueryParam {
  const _$QueryParamImpl({required this.name, required this.value});

  factory _$QueryParamImpl.fromJson(Map<String, dynamic> json) =>
      _$$QueryParamImplFromJson(json);

  @override
  final String name;
  @override
  final String value;

  @override
  String toString() {
    return 'QueryParam(name: $name, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueryParamImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, value);

  /// Create a copy of QueryParam
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QueryParamImplCopyWith<_$QueryParamImpl> get copyWith =>
      __$$QueryParamImplCopyWithImpl<_$QueryParamImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QueryParamImplToJson(
      this,
    );
  }
}

abstract class _QueryParam implements QueryParam {
  const factory _QueryParam(
      {required final String name,
      required final String value}) = _$QueryParamImpl;

  factory _QueryParam.fromJson(Map<String, dynamic> json) =
      _$QueryParamImpl.fromJson;

  @override
  String get name;
  @override
  String get value;

  /// Create a copy of QueryParam
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueryParamImplCopyWith<_$QueryParamImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
