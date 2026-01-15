// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'load_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LoadState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get completeMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LoadStateCopyWith<LoadState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoadStateCopyWith<$Res> {
  factory $LoadStateCopyWith(LoadState value, $Res Function(LoadState) then) =
      _$LoadStateCopyWithImpl<$Res, LoadState>;
  @useResult
  $Res call({bool isLoading, String? errorMessage, String? completeMessage});
}

/// @nodoc
class _$LoadStateCopyWithImpl<$Res, $Val extends LoadState>
    implements $LoadStateCopyWith<$Res> {
  _$LoadStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? completeMessage = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      completeMessage: freezed == completeMessage
          ? _value.completeMessage
          : completeMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoadStateImplCopyWith<$Res>
    implements $LoadStateCopyWith<$Res> {
  factory _$$LoadStateImplCopyWith(
          _$LoadStateImpl value, $Res Function(_$LoadStateImpl) then) =
      __$$LoadStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, String? errorMessage, String? completeMessage});
}

/// @nodoc
class __$$LoadStateImplCopyWithImpl<$Res>
    extends _$LoadStateCopyWithImpl<$Res, _$LoadStateImpl>
    implements _$$LoadStateImplCopyWith<$Res> {
  __$$LoadStateImplCopyWithImpl(
      _$LoadStateImpl _value, $Res Function(_$LoadStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? completeMessage = freezed,
  }) {
    return _then(_$LoadStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      completeMessage: freezed == completeMessage
          ? _value.completeMessage
          : completeMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LoadStateImpl extends _LoadState {
  const _$LoadStateImpl(
      {this.isLoading = false, this.errorMessage, this.completeMessage})
      : super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  final String? completeMessage;

  @override
  String toString() {
    return 'LoadState(isLoading: $isLoading, errorMessage: $errorMessage, completeMessage: $completeMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.completeMessage, completeMessage) ||
                other.completeMessage == completeMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, errorMessage, completeMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadStateImplCopyWith<_$LoadStateImpl> get copyWith =>
      __$$LoadStateImplCopyWithImpl<_$LoadStateImpl>(this, _$identity);
}

abstract class _LoadState extends LoadState {
  const factory _LoadState(
      {final bool isLoading,
      final String? errorMessage,
      final String? completeMessage}) = _$LoadStateImpl;
  const _LoadState._() : super._();

  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  String? get completeMessage;
  @override
  @JsonKey(ignore: true)
  _$$LoadStateImplCopyWith<_$LoadStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
