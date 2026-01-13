// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OnboardingState {
//주소 검색 오류 상태
  bool get isError => throw _privateConstructorUsedError;
  String get nicknameState => throw _privateConstructorUsedError;
  bool get completeSetNickName => throw _privateConstructorUsedError;
  String get userNickName => throw _privateConstructorUsedError; //입력한 주소값
  String get homeJuso => throw _privateConstructorUsedError;
  String get firstJuso => throw _privateConstructorUsedError;
  String get secondJuso => throw _privateConstructorUsedError; //입력한 주소 별명
  String get homeJusoNick => throw _privateConstructorUsedError;
  String get firstJusoNick => throw _privateConstructorUsedError;
  String get secondJusoNick =>
      throw _privateConstructorUsedError; //주소 별명 입력 오류 상태
  String get firstJusoState => throw _privateConstructorUsedError;
  String get secondJusoState =>
      throw _privateConstructorUsedError; //주소 입력 텍스트 필드 visible 상태
  bool get isJuso1Visible => throw _privateConstructorUsedError;
  bool get isJuso2Visible =>
      throw _privateConstructorUsedError; //권한 모두 동의 활성화 상태
  bool get isAllAppPermissionGrant =>
      throw _privateConstructorUsedError; //체크박스의 활성화상태
  List<bool> get isAppPermissionCheckboxState =>
      throw _privateConstructorUsedError;
  List<String> get disasterTypes => throw _privateConstructorUsedError;
  List<String> get termList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OnboardingStateCopyWith<OnboardingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStateCopyWith<$Res> {
  factory $OnboardingStateCopyWith(
          OnboardingState value, $Res Function(OnboardingState) then) =
      _$OnboardingStateCopyWithImpl<$Res, OnboardingState>;
  @useResult
  $Res call(
      {bool isError,
      String nicknameState,
      bool completeSetNickName,
      String userNickName,
      String homeJuso,
      String firstJuso,
      String secondJuso,
      String homeJusoNick,
      String firstJusoNick,
      String secondJusoNick,
      String firstJusoState,
      String secondJusoState,
      bool isJuso1Visible,
      bool isJuso2Visible,
      bool isAllAppPermissionGrant,
      List<bool> isAppPermissionCheckboxState,
      List<String> disasterTypes,
      List<String> termList});
}

/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res, $Val extends OnboardingState>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isError = null,
    Object? nicknameState = null,
    Object? completeSetNickName = null,
    Object? userNickName = null,
    Object? homeJuso = null,
    Object? firstJuso = null,
    Object? secondJuso = null,
    Object? homeJusoNick = null,
    Object? firstJusoNick = null,
    Object? secondJusoNick = null,
    Object? firstJusoState = null,
    Object? secondJusoState = null,
    Object? isJuso1Visible = null,
    Object? isJuso2Visible = null,
    Object? isAllAppPermissionGrant = null,
    Object? isAppPermissionCheckboxState = null,
    Object? disasterTypes = null,
    Object? termList = null,
  }) {
    return _then(_value.copyWith(
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
      nicknameState: null == nicknameState
          ? _value.nicknameState
          : nicknameState // ignore: cast_nullable_to_non_nullable
              as String,
      completeSetNickName: null == completeSetNickName
          ? _value.completeSetNickName
          : completeSetNickName // ignore: cast_nullable_to_non_nullable
              as bool,
      userNickName: null == userNickName
          ? _value.userNickName
          : userNickName // ignore: cast_nullable_to_non_nullable
              as String,
      homeJuso: null == homeJuso
          ? _value.homeJuso
          : homeJuso // ignore: cast_nullable_to_non_nullable
              as String,
      firstJuso: null == firstJuso
          ? _value.firstJuso
          : firstJuso // ignore: cast_nullable_to_non_nullable
              as String,
      secondJuso: null == secondJuso
          ? _value.secondJuso
          : secondJuso // ignore: cast_nullable_to_non_nullable
              as String,
      homeJusoNick: null == homeJusoNick
          ? _value.homeJusoNick
          : homeJusoNick // ignore: cast_nullable_to_non_nullable
              as String,
      firstJusoNick: null == firstJusoNick
          ? _value.firstJusoNick
          : firstJusoNick // ignore: cast_nullable_to_non_nullable
              as String,
      secondJusoNick: null == secondJusoNick
          ? _value.secondJusoNick
          : secondJusoNick // ignore: cast_nullable_to_non_nullable
              as String,
      firstJusoState: null == firstJusoState
          ? _value.firstJusoState
          : firstJusoState // ignore: cast_nullable_to_non_nullable
              as String,
      secondJusoState: null == secondJusoState
          ? _value.secondJusoState
          : secondJusoState // ignore: cast_nullable_to_non_nullable
              as String,
      isJuso1Visible: null == isJuso1Visible
          ? _value.isJuso1Visible
          : isJuso1Visible // ignore: cast_nullable_to_non_nullable
              as bool,
      isJuso2Visible: null == isJuso2Visible
          ? _value.isJuso2Visible
          : isJuso2Visible // ignore: cast_nullable_to_non_nullable
              as bool,
      isAllAppPermissionGrant: null == isAllAppPermissionGrant
          ? _value.isAllAppPermissionGrant
          : isAllAppPermissionGrant // ignore: cast_nullable_to_non_nullable
              as bool,
      isAppPermissionCheckboxState: null == isAppPermissionCheckboxState
          ? _value.isAppPermissionCheckboxState
          : isAppPermissionCheckboxState // ignore: cast_nullable_to_non_nullable
              as List<bool>,
      disasterTypes: null == disasterTypes
          ? _value.disasterTypes
          : disasterTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      termList: null == termList
          ? _value.termList
          : termList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingStateImplCopyWith<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  factory _$$OnboardingStateImplCopyWith(_$OnboardingStateImpl value,
          $Res Function(_$OnboardingStateImpl) then) =
      __$$OnboardingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isError,
      String nicknameState,
      bool completeSetNickName,
      String userNickName,
      String homeJuso,
      String firstJuso,
      String secondJuso,
      String homeJusoNick,
      String firstJusoNick,
      String secondJusoNick,
      String firstJusoState,
      String secondJusoState,
      bool isJuso1Visible,
      bool isJuso2Visible,
      bool isAllAppPermissionGrant,
      List<bool> isAppPermissionCheckboxState,
      List<String> disasterTypes,
      List<String> termList});
}

/// @nodoc
class __$$OnboardingStateImplCopyWithImpl<$Res>
    extends _$OnboardingStateCopyWithImpl<$Res, _$OnboardingStateImpl>
    implements _$$OnboardingStateImplCopyWith<$Res> {
  __$$OnboardingStateImplCopyWithImpl(
      _$OnboardingStateImpl _value, $Res Function(_$OnboardingStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isError = null,
    Object? nicknameState = null,
    Object? completeSetNickName = null,
    Object? userNickName = null,
    Object? homeJuso = null,
    Object? firstJuso = null,
    Object? secondJuso = null,
    Object? homeJusoNick = null,
    Object? firstJusoNick = null,
    Object? secondJusoNick = null,
    Object? firstJusoState = null,
    Object? secondJusoState = null,
    Object? isJuso1Visible = null,
    Object? isJuso2Visible = null,
    Object? isAllAppPermissionGrant = null,
    Object? isAppPermissionCheckboxState = null,
    Object? disasterTypes = null,
    Object? termList = null,
  }) {
    return _then(_$OnboardingStateImpl(
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
      nicknameState: null == nicknameState
          ? _value.nicknameState
          : nicknameState // ignore: cast_nullable_to_non_nullable
              as String,
      completeSetNickName: null == completeSetNickName
          ? _value.completeSetNickName
          : completeSetNickName // ignore: cast_nullable_to_non_nullable
              as bool,
      userNickName: null == userNickName
          ? _value.userNickName
          : userNickName // ignore: cast_nullable_to_non_nullable
              as String,
      homeJuso: null == homeJuso
          ? _value.homeJuso
          : homeJuso // ignore: cast_nullable_to_non_nullable
              as String,
      firstJuso: null == firstJuso
          ? _value.firstJuso
          : firstJuso // ignore: cast_nullable_to_non_nullable
              as String,
      secondJuso: null == secondJuso
          ? _value.secondJuso
          : secondJuso // ignore: cast_nullable_to_non_nullable
              as String,
      homeJusoNick: null == homeJusoNick
          ? _value.homeJusoNick
          : homeJusoNick // ignore: cast_nullable_to_non_nullable
              as String,
      firstJusoNick: null == firstJusoNick
          ? _value.firstJusoNick
          : firstJusoNick // ignore: cast_nullable_to_non_nullable
              as String,
      secondJusoNick: null == secondJusoNick
          ? _value.secondJusoNick
          : secondJusoNick // ignore: cast_nullable_to_non_nullable
              as String,
      firstJusoState: null == firstJusoState
          ? _value.firstJusoState
          : firstJusoState // ignore: cast_nullable_to_non_nullable
              as String,
      secondJusoState: null == secondJusoState
          ? _value.secondJusoState
          : secondJusoState // ignore: cast_nullable_to_non_nullable
              as String,
      isJuso1Visible: null == isJuso1Visible
          ? _value.isJuso1Visible
          : isJuso1Visible // ignore: cast_nullable_to_non_nullable
              as bool,
      isJuso2Visible: null == isJuso2Visible
          ? _value.isJuso2Visible
          : isJuso2Visible // ignore: cast_nullable_to_non_nullable
              as bool,
      isAllAppPermissionGrant: null == isAllAppPermissionGrant
          ? _value.isAllAppPermissionGrant
          : isAllAppPermissionGrant // ignore: cast_nullable_to_non_nullable
              as bool,
      isAppPermissionCheckboxState: null == isAppPermissionCheckboxState
          ? _value._isAppPermissionCheckboxState
          : isAppPermissionCheckboxState // ignore: cast_nullable_to_non_nullable
              as List<bool>,
      disasterTypes: null == disasterTypes
          ? _value._disasterTypes
          : disasterTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      termList: null == termList
          ? _value._termList
          : termList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$OnboardingStateImpl implements _OnboardingState {
  _$OnboardingStateImpl(
      {this.isError = false,
      this.nicknameState = '',
      this.completeSetNickName = false,
      this.userNickName = '',
      this.homeJuso = '',
      this.firstJuso = '',
      this.secondJuso = '',
      this.homeJusoNick = '집',
      this.firstJusoNick = '',
      this.secondJusoNick = '',
      this.firstJusoState = '*별명 설정은 필수입니다.',
      this.secondJusoState = '*별명 설정은 필수입니다.',
      this.isJuso1Visible = false,
      this.isJuso2Visible = false,
      this.isAllAppPermissionGrant = false,
      final List<bool> isAppPermissionCheckboxState = const [
        false,
        false,
        false,
        false,
        false
      ],
      final List<String> disasterTypes = const [],
      final List<String> termList = const [
        '(필수) 만 14세 이상입니다.',
        '(필수) 서비스 이용약관 동의',
        '(필수) 개인 정보 수집 ・ 이용 동의',
        '(필수) 위치정보 이용 동의'
      ]})
      : _isAppPermissionCheckboxState = isAppPermissionCheckboxState,
        _disasterTypes = disasterTypes,
        _termList = termList;

//주소 검색 오류 상태
  @override
  @JsonKey()
  final bool isError;
  @override
  @JsonKey()
  final String nicknameState;
  @override
  @JsonKey()
  final bool completeSetNickName;
  @override
  @JsonKey()
  final String userNickName;
//입력한 주소값
  @override
  @JsonKey()
  final String homeJuso;
  @override
  @JsonKey()
  final String firstJuso;
  @override
  @JsonKey()
  final String secondJuso;
//입력한 주소 별명
  @override
  @JsonKey()
  final String homeJusoNick;
  @override
  @JsonKey()
  final String firstJusoNick;
  @override
  @JsonKey()
  final String secondJusoNick;
//주소 별명 입력 오류 상태
  @override
  @JsonKey()
  final String firstJusoState;
  @override
  @JsonKey()
  final String secondJusoState;
//주소 입력 텍스트 필드 visible 상태
  @override
  @JsonKey()
  final bool isJuso1Visible;
  @override
  @JsonKey()
  final bool isJuso2Visible;
//권한 모두 동의 활성화 상태
  @override
  @JsonKey()
  final bool isAllAppPermissionGrant;
//체크박스의 활성화상태
  final List<bool> _isAppPermissionCheckboxState;
//체크박스의 활성화상태
  @override
  @JsonKey()
  List<bool> get isAppPermissionCheckboxState {
    if (_isAppPermissionCheckboxState is EqualUnmodifiableListView)
      return _isAppPermissionCheckboxState;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_isAppPermissionCheckboxState);
  }

  final List<String> _disasterTypes;
  @override
  @JsonKey()
  List<String> get disasterTypes {
    if (_disasterTypes is EqualUnmodifiableListView) return _disasterTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_disasterTypes);
  }

  final List<String> _termList;
  @override
  @JsonKey()
  List<String> get termList {
    if (_termList is EqualUnmodifiableListView) return _termList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_termList);
  }

  @override
  String toString() {
    return 'OnboardingState(isError: $isError, nicknameState: $nicknameState, completeSetNickName: $completeSetNickName, userNickName: $userNickName, homeJuso: $homeJuso, firstJuso: $firstJuso, secondJuso: $secondJuso, homeJusoNick: $homeJusoNick, firstJusoNick: $firstJusoNick, secondJusoNick: $secondJusoNick, firstJusoState: $firstJusoState, secondJusoState: $secondJusoState, isJuso1Visible: $isJuso1Visible, isJuso2Visible: $isJuso2Visible, isAllAppPermissionGrant: $isAllAppPermissionGrant, isAppPermissionCheckboxState: $isAppPermissionCheckboxState, disasterTypes: $disasterTypes, termList: $termList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingStateImpl &&
            (identical(other.isError, isError) || other.isError == isError) &&
            (identical(other.nicknameState, nicknameState) ||
                other.nicknameState == nicknameState) &&
            (identical(other.completeSetNickName, completeSetNickName) ||
                other.completeSetNickName == completeSetNickName) &&
            (identical(other.userNickName, userNickName) ||
                other.userNickName == userNickName) &&
            (identical(other.homeJuso, homeJuso) ||
                other.homeJuso == homeJuso) &&
            (identical(other.firstJuso, firstJuso) ||
                other.firstJuso == firstJuso) &&
            (identical(other.secondJuso, secondJuso) ||
                other.secondJuso == secondJuso) &&
            (identical(other.homeJusoNick, homeJusoNick) ||
                other.homeJusoNick == homeJusoNick) &&
            (identical(other.firstJusoNick, firstJusoNick) ||
                other.firstJusoNick == firstJusoNick) &&
            (identical(other.secondJusoNick, secondJusoNick) ||
                other.secondJusoNick == secondJusoNick) &&
            (identical(other.firstJusoState, firstJusoState) ||
                other.firstJusoState == firstJusoState) &&
            (identical(other.secondJusoState, secondJusoState) ||
                other.secondJusoState == secondJusoState) &&
            (identical(other.isJuso1Visible, isJuso1Visible) ||
                other.isJuso1Visible == isJuso1Visible) &&
            (identical(other.isJuso2Visible, isJuso2Visible) ||
                other.isJuso2Visible == isJuso2Visible) &&
            (identical(
                    other.isAllAppPermissionGrant, isAllAppPermissionGrant) ||
                other.isAllAppPermissionGrant == isAllAppPermissionGrant) &&
            const DeepCollectionEquality().equals(
                other._isAppPermissionCheckboxState,
                _isAppPermissionCheckboxState) &&
            const DeepCollectionEquality()
                .equals(other._disasterTypes, _disasterTypes) &&
            const DeepCollectionEquality().equals(other._termList, _termList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isError,
      nicknameState,
      completeSetNickName,
      userNickName,
      homeJuso,
      firstJuso,
      secondJuso,
      homeJusoNick,
      firstJusoNick,
      secondJusoNick,
      firstJusoState,
      secondJusoState,
      isJuso1Visible,
      isJuso2Visible,
      isAllAppPermissionGrant,
      const DeepCollectionEquality().hash(_isAppPermissionCheckboxState),
      const DeepCollectionEquality().hash(_disasterTypes),
      const DeepCollectionEquality().hash(_termList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingStateImplCopyWith<_$OnboardingStateImpl> get copyWith =>
      __$$OnboardingStateImplCopyWithImpl<_$OnboardingStateImpl>(
          this, _$identity);
}

abstract class _OnboardingState implements OnboardingState {
  factory _OnboardingState(
      {final bool isError,
      final String nicknameState,
      final bool completeSetNickName,
      final String userNickName,
      final String homeJuso,
      final String firstJuso,
      final String secondJuso,
      final String homeJusoNick,
      final String firstJusoNick,
      final String secondJusoNick,
      final String firstJusoState,
      final String secondJusoState,
      final bool isJuso1Visible,
      final bool isJuso2Visible,
      final bool isAllAppPermissionGrant,
      final List<bool> isAppPermissionCheckboxState,
      final List<String> disasterTypes,
      final List<String> termList}) = _$OnboardingStateImpl;

  @override //주소 검색 오류 상태
  bool get isError;
  @override
  String get nicknameState;
  @override
  bool get completeSetNickName;
  @override
  String get userNickName;
  @override //입력한 주소값
  String get homeJuso;
  @override
  String get firstJuso;
  @override
  String get secondJuso;
  @override //입력한 주소 별명
  String get homeJusoNick;
  @override
  String get firstJusoNick;
  @override
  String get secondJusoNick;
  @override //주소 별명 입력 오류 상태
  String get firstJusoState;
  @override
  String get secondJusoState;
  @override //주소 입력 텍스트 필드 visible 상태
  bool get isJuso1Visible;
  @override
  bool get isJuso2Visible;
  @override //권한 모두 동의 활성화 상태
  bool get isAllAppPermissionGrant;
  @override //체크박스의 활성화상태
  List<bool> get isAppPermissionCheckboxState;
  @override
  List<String> get disasterTypes;
  @override
  List<String> get termList;
  @override
  @JsonKey(ignore: true)
  _$$OnboardingStateImplCopyWith<_$OnboardingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
