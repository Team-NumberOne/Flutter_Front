// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mypage_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MyPageState {
  dynamic get isLoading => throw _privateConstructorUsedError;

  /// 사용자 정보 수정
  dynamic get profileImgUrl => throw _privateConstructorUsedError;
  dynamic get nickName => throw _privateConstructorUsedError;
  String get nicknameState => throw _privateConstructorUsedError;
  bool get completeSetNickName => throw _privateConstructorUsedError;
  dynamic get communityAlarmState => throw _privateConstructorUsedError;
  dynamic get disasterAlarmState => throw _privateConstructorUsedError;
  List<String> get disasterTypeList => throw _privateConstructorUsedError;
  List<String> get inquireTypeList => throw _privateConstructorUsedError;
  String get inquireType => throw _privateConstructorUsedError;
  bool get isArticleHasMore => throw _privateConstructorUsedError;
  List<UserArticle> get myArticles => throw _privateConstructorUsedError;
  bool get isArticleLoading => throw _privateConstructorUsedError;

  /// 재난 지역 설정에 대한 상태값
//입력한 주소값
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
  bool get isJuso2Visible => throw _privateConstructorUsedError; //주소 검색 오류 상태
  bool get isError => throw _privateConstructorUsedError; //공지사항
  List<Announcements> get announcementList =>
      throw _privateConstructorUsedError;
  AnnouncementDetailResponse? get announcementDetailResponse =>
      throw _privateConstructorUsedError; //탈퇴 이유
  List<String> get leaveTypeList => throw _privateConstructorUsedError;
  String get leaveType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MyPageStateCopyWith<MyPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyPageStateCopyWith<$Res> {
  factory $MyPageStateCopyWith(
          MyPageState value, $Res Function(MyPageState) then) =
      _$MyPageStateCopyWithImpl<$Res, MyPageState>;
  @useResult
  $Res call(
      {dynamic isLoading,
      dynamic profileImgUrl,
      dynamic nickName,
      String nicknameState,
      bool completeSetNickName,
      dynamic communityAlarmState,
      dynamic disasterAlarmState,
      List<String> disasterTypeList,
      List<String> inquireTypeList,
      String inquireType,
      bool isArticleHasMore,
      List<UserArticle> myArticles,
      bool isArticleLoading,
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
      bool isError,
      List<Announcements> announcementList,
      AnnouncementDetailResponse? announcementDetailResponse,
      List<String> leaveTypeList,
      String leaveType});
}

/// @nodoc
class _$MyPageStateCopyWithImpl<$Res, $Val extends MyPageState>
    implements $MyPageStateCopyWith<$Res> {
  _$MyPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = freezed,
    Object? profileImgUrl = freezed,
    Object? nickName = freezed,
    Object? nicknameState = null,
    Object? completeSetNickName = null,
    Object? communityAlarmState = freezed,
    Object? disasterAlarmState = freezed,
    Object? disasterTypeList = null,
    Object? inquireTypeList = null,
    Object? inquireType = null,
    Object? isArticleHasMore = null,
    Object? myArticles = null,
    Object? isArticleLoading = null,
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
    Object? isError = null,
    Object? announcementList = null,
    Object? announcementDetailResponse = freezed,
    Object? leaveTypeList = null,
    Object? leaveType = null,
  }) {
    return _then(_value.copyWith(
      isLoading: freezed == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as dynamic,
      profileImgUrl: freezed == profileImgUrl
          ? _value.profileImgUrl
          : profileImgUrl // ignore: cast_nullable_to_non_nullable
              as dynamic,
      nickName: freezed == nickName
          ? _value.nickName
          : nickName // ignore: cast_nullable_to_non_nullable
              as dynamic,
      nicknameState: null == nicknameState
          ? _value.nicknameState
          : nicknameState // ignore: cast_nullable_to_non_nullable
              as String,
      completeSetNickName: null == completeSetNickName
          ? _value.completeSetNickName
          : completeSetNickName // ignore: cast_nullable_to_non_nullable
              as bool,
      communityAlarmState: freezed == communityAlarmState
          ? _value.communityAlarmState
          : communityAlarmState // ignore: cast_nullable_to_non_nullable
              as dynamic,
      disasterAlarmState: freezed == disasterAlarmState
          ? _value.disasterAlarmState
          : disasterAlarmState // ignore: cast_nullable_to_non_nullable
              as dynamic,
      disasterTypeList: null == disasterTypeList
          ? _value.disasterTypeList
          : disasterTypeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inquireTypeList: null == inquireTypeList
          ? _value.inquireTypeList
          : inquireTypeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inquireType: null == inquireType
          ? _value.inquireType
          : inquireType // ignore: cast_nullable_to_non_nullable
              as String,
      isArticleHasMore: null == isArticleHasMore
          ? _value.isArticleHasMore
          : isArticleHasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      myArticles: null == myArticles
          ? _value.myArticles
          : myArticles // ignore: cast_nullable_to_non_nullable
              as List<UserArticle>,
      isArticleLoading: null == isArticleLoading
          ? _value.isArticleLoading
          : isArticleLoading // ignore: cast_nullable_to_non_nullable
              as bool,
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
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
      announcementList: null == announcementList
          ? _value.announcementList
          : announcementList // ignore: cast_nullable_to_non_nullable
              as List<Announcements>,
      announcementDetailResponse: freezed == announcementDetailResponse
          ? _value.announcementDetailResponse
          : announcementDetailResponse // ignore: cast_nullable_to_non_nullable
              as AnnouncementDetailResponse?,
      leaveTypeList: null == leaveTypeList
          ? _value.leaveTypeList
          : leaveTypeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      leaveType: null == leaveType
          ? _value.leaveType
          : leaveType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MyPageStateImplCopyWith<$Res>
    implements $MyPageStateCopyWith<$Res> {
  factory _$$MyPageStateImplCopyWith(
          _$MyPageStateImpl value, $Res Function(_$MyPageStateImpl) then) =
      __$$MyPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {dynamic isLoading,
      dynamic profileImgUrl,
      dynamic nickName,
      String nicknameState,
      bool completeSetNickName,
      dynamic communityAlarmState,
      dynamic disasterAlarmState,
      List<String> disasterTypeList,
      List<String> inquireTypeList,
      String inquireType,
      bool isArticleHasMore,
      List<UserArticle> myArticles,
      bool isArticleLoading,
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
      bool isError,
      List<Announcements> announcementList,
      AnnouncementDetailResponse? announcementDetailResponse,
      List<String> leaveTypeList,
      String leaveType});
}

/// @nodoc
class __$$MyPageStateImplCopyWithImpl<$Res>
    extends _$MyPageStateCopyWithImpl<$Res, _$MyPageStateImpl>
    implements _$$MyPageStateImplCopyWith<$Res> {
  __$$MyPageStateImplCopyWithImpl(
      _$MyPageStateImpl _value, $Res Function(_$MyPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = freezed,
    Object? profileImgUrl = freezed,
    Object? nickName = freezed,
    Object? nicknameState = null,
    Object? completeSetNickName = null,
    Object? communityAlarmState = freezed,
    Object? disasterAlarmState = freezed,
    Object? disasterTypeList = null,
    Object? inquireTypeList = null,
    Object? inquireType = null,
    Object? isArticleHasMore = null,
    Object? myArticles = null,
    Object? isArticleLoading = null,
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
    Object? isError = null,
    Object? announcementList = null,
    Object? announcementDetailResponse = freezed,
    Object? leaveTypeList = null,
    Object? leaveType = null,
  }) {
    return _then(_$MyPageStateImpl(
      isLoading: freezed == isLoading ? _value.isLoading! : isLoading,
      profileImgUrl:
          freezed == profileImgUrl ? _value.profileImgUrl! : profileImgUrl,
      nickName: freezed == nickName ? _value.nickName! : nickName,
      nicknameState: null == nicknameState
          ? _value.nicknameState
          : nicknameState // ignore: cast_nullable_to_non_nullable
              as String,
      completeSetNickName: null == completeSetNickName
          ? _value.completeSetNickName
          : completeSetNickName // ignore: cast_nullable_to_non_nullable
              as bool,
      communityAlarmState: freezed == communityAlarmState
          ? _value.communityAlarmState!
          : communityAlarmState,
      disasterAlarmState: freezed == disasterAlarmState
          ? _value.disasterAlarmState!
          : disasterAlarmState,
      disasterTypeList: null == disasterTypeList
          ? _value._disasterTypeList
          : disasterTypeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inquireTypeList: null == inquireTypeList
          ? _value._inquireTypeList
          : inquireTypeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inquireType: null == inquireType
          ? _value.inquireType
          : inquireType // ignore: cast_nullable_to_non_nullable
              as String,
      isArticleHasMore: null == isArticleHasMore
          ? _value.isArticleHasMore
          : isArticleHasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      myArticles: null == myArticles
          ? _value._myArticles
          : myArticles // ignore: cast_nullable_to_non_nullable
              as List<UserArticle>,
      isArticleLoading: null == isArticleLoading
          ? _value.isArticleLoading
          : isArticleLoading // ignore: cast_nullable_to_non_nullable
              as bool,
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
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
      announcementList: null == announcementList
          ? _value._announcementList
          : announcementList // ignore: cast_nullable_to_non_nullable
              as List<Announcements>,
      announcementDetailResponse: freezed == announcementDetailResponse
          ? _value.announcementDetailResponse
          : announcementDetailResponse // ignore: cast_nullable_to_non_nullable
              as AnnouncementDetailResponse?,
      leaveTypeList: null == leaveTypeList
          ? _value._leaveTypeList
          : leaveTypeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      leaveType: null == leaveType
          ? _value.leaveType
          : leaveType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$MyPageStateImpl implements _MyPageState {
  _$MyPageStateImpl(
      {this.isLoading = true,
      this.profileImgUrl = '',
      this.nickName = '',
      this.nicknameState = '',
      this.completeSetNickName = false,
      this.communityAlarmState = false,
      this.disasterAlarmState = false,
      final List<String> disasterTypeList = const [],
      final List<String> inquireTypeList = const [
        '서비스 개선',
        '재난 알림 및 정보',
        '커뮤니티 이용',
        '기타'
      ],
      this.inquireType = '',
      this.isArticleHasMore = true,
      final List<UserArticle> myArticles = const [],
      this.isArticleLoading = true,
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
      this.isError = false,
      final List<Announcements> announcementList = const [],
      this.announcementDetailResponse = null,
      final List<String> leaveTypeList = const [
        '새 계정을 만들고 싶어요.',
        '알림이 너무 자주 와요.',
        '정보가 부족해요.',
        '불쾌한 사람을 만났어요.',
        '기타'
      ],
      this.leaveType = ''})
      : _disasterTypeList = disasterTypeList,
        _inquireTypeList = inquireTypeList,
        _myArticles = myArticles,
        _announcementList = announcementList,
        _leaveTypeList = leaveTypeList;

  @override
  @JsonKey()
  final dynamic isLoading;

  /// 사용자 정보 수정
  @override
  @JsonKey()
  final dynamic profileImgUrl;
  @override
  @JsonKey()
  final dynamic nickName;
  @override
  @JsonKey()
  final String nicknameState;
  @override
  @JsonKey()
  final bool completeSetNickName;
  @override
  @JsonKey()
  final dynamic communityAlarmState;
  @override
  @JsonKey()
  final dynamic disasterAlarmState;
  final List<String> _disasterTypeList;
  @override
  @JsonKey()
  List<String> get disasterTypeList {
    if (_disasterTypeList is EqualUnmodifiableListView)
      return _disasterTypeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_disasterTypeList);
  }

  final List<String> _inquireTypeList;
  @override
  @JsonKey()
  List<String> get inquireTypeList {
    if (_inquireTypeList is EqualUnmodifiableListView) return _inquireTypeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inquireTypeList);
  }

  @override
  @JsonKey()
  final String inquireType;
  @override
  @JsonKey()
  final bool isArticleHasMore;
  final List<UserArticle> _myArticles;
  @override
  @JsonKey()
  List<UserArticle> get myArticles {
    if (_myArticles is EqualUnmodifiableListView) return _myArticles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_myArticles);
  }

  @override
  @JsonKey()
  final bool isArticleLoading;

  /// 재난 지역 설정에 대한 상태값
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
//주소 검색 오류 상태
  @override
  @JsonKey()
  final bool isError;
//공지사항
  final List<Announcements> _announcementList;
//공지사항
  @override
  @JsonKey()
  List<Announcements> get announcementList {
    if (_announcementList is EqualUnmodifiableListView)
      return _announcementList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_announcementList);
  }

  @override
  @JsonKey()
  final AnnouncementDetailResponse? announcementDetailResponse;
//탈퇴 이유
  final List<String> _leaveTypeList;
//탈퇴 이유
  @override
  @JsonKey()
  List<String> get leaveTypeList {
    if (_leaveTypeList is EqualUnmodifiableListView) return _leaveTypeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_leaveTypeList);
  }

  @override
  @JsonKey()
  final String leaveType;

  @override
  String toString() {
    return 'MyPageState(isLoading: $isLoading, profileImgUrl: $profileImgUrl, nickName: $nickName, nicknameState: $nicknameState, completeSetNickName: $completeSetNickName, communityAlarmState: $communityAlarmState, disasterAlarmState: $disasterAlarmState, disasterTypeList: $disasterTypeList, inquireTypeList: $inquireTypeList, inquireType: $inquireType, isArticleHasMore: $isArticleHasMore, myArticles: $myArticles, isArticleLoading: $isArticleLoading, homeJuso: $homeJuso, firstJuso: $firstJuso, secondJuso: $secondJuso, homeJusoNick: $homeJusoNick, firstJusoNick: $firstJusoNick, secondJusoNick: $secondJusoNick, firstJusoState: $firstJusoState, secondJusoState: $secondJusoState, isJuso1Visible: $isJuso1Visible, isJuso2Visible: $isJuso2Visible, isError: $isError, announcementList: $announcementList, announcementDetailResponse: $announcementDetailResponse, leaveTypeList: $leaveTypeList, leaveType: $leaveType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyPageStateImpl &&
            const DeepCollectionEquality().equals(other.isLoading, isLoading) &&
            const DeepCollectionEquality()
                .equals(other.profileImgUrl, profileImgUrl) &&
            const DeepCollectionEquality().equals(other.nickName, nickName) &&
            (identical(other.nicknameState, nicknameState) ||
                other.nicknameState == nicknameState) &&
            (identical(other.completeSetNickName, completeSetNickName) ||
                other.completeSetNickName == completeSetNickName) &&
            const DeepCollectionEquality()
                .equals(other.communityAlarmState, communityAlarmState) &&
            const DeepCollectionEquality()
                .equals(other.disasterAlarmState, disasterAlarmState) &&
            const DeepCollectionEquality()
                .equals(other._disasterTypeList, _disasterTypeList) &&
            const DeepCollectionEquality()
                .equals(other._inquireTypeList, _inquireTypeList) &&
            (identical(other.inquireType, inquireType) ||
                other.inquireType == inquireType) &&
            (identical(other.isArticleHasMore, isArticleHasMore) ||
                other.isArticleHasMore == isArticleHasMore) &&
            const DeepCollectionEquality()
                .equals(other._myArticles, _myArticles) &&
            (identical(other.isArticleLoading, isArticleLoading) ||
                other.isArticleLoading == isArticleLoading) &&
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
            (identical(other.isError, isError) || other.isError == isError) &&
            const DeepCollectionEquality()
                .equals(other._announcementList, _announcementList) &&
            (identical(other.announcementDetailResponse,
                    announcementDetailResponse) ||
                other.announcementDetailResponse ==
                    announcementDetailResponse) &&
            const DeepCollectionEquality()
                .equals(other._leaveTypeList, _leaveTypeList) &&
            (identical(other.leaveType, leaveType) ||
                other.leaveType == leaveType));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(isLoading),
        const DeepCollectionEquality().hash(profileImgUrl),
        const DeepCollectionEquality().hash(nickName),
        nicknameState,
        completeSetNickName,
        const DeepCollectionEquality().hash(communityAlarmState),
        const DeepCollectionEquality().hash(disasterAlarmState),
        const DeepCollectionEquality().hash(_disasterTypeList),
        const DeepCollectionEquality().hash(_inquireTypeList),
        inquireType,
        isArticleHasMore,
        const DeepCollectionEquality().hash(_myArticles),
        isArticleLoading,
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
        isError,
        const DeepCollectionEquality().hash(_announcementList),
        announcementDetailResponse,
        const DeepCollectionEquality().hash(_leaveTypeList),
        leaveType
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MyPageStateImplCopyWith<_$MyPageStateImpl> get copyWith =>
      __$$MyPageStateImplCopyWithImpl<_$MyPageStateImpl>(this, _$identity);
}

abstract class _MyPageState implements MyPageState {
  factory _MyPageState(
      {final dynamic isLoading,
      final dynamic profileImgUrl,
      final dynamic nickName,
      final String nicknameState,
      final bool completeSetNickName,
      final dynamic communityAlarmState,
      final dynamic disasterAlarmState,
      final List<String> disasterTypeList,
      final List<String> inquireTypeList,
      final String inquireType,
      final bool isArticleHasMore,
      final List<UserArticle> myArticles,
      final bool isArticleLoading,
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
      final bool isError,
      final List<Announcements> announcementList,
      final AnnouncementDetailResponse? announcementDetailResponse,
      final List<String> leaveTypeList,
      final String leaveType}) = _$MyPageStateImpl;

  @override
  dynamic get isLoading;
  @override

  /// 사용자 정보 수정
  dynamic get profileImgUrl;
  @override
  dynamic get nickName;
  @override
  String get nicknameState;
  @override
  bool get completeSetNickName;
  @override
  dynamic get communityAlarmState;
  @override
  dynamic get disasterAlarmState;
  @override
  List<String> get disasterTypeList;
  @override
  List<String> get inquireTypeList;
  @override
  String get inquireType;
  @override
  bool get isArticleHasMore;
  @override
  List<UserArticle> get myArticles;
  @override
  bool get isArticleLoading;
  @override

  /// 재난 지역 설정에 대한 상태값
//입력한 주소값
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
  @override //주소 검색 오류 상태
  bool get isError;
  @override //공지사항
  List<Announcements> get announcementList;
  @override
  AnnouncementDetailResponse? get announcementDetailResponse;
  @override //탈퇴 이유
  List<String> get leaveTypeList;
  @override
  String get leaveType;
  @override
  @JsonKey(ignore: true)
  _$$MyPageStateImplCopyWith<_$MyPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
