import 'package:daepiro/data/model/request/set_mypage_disaster_types_request.dart';
import 'package:daepiro/data/model/request/set_mypage_inquires_request.dart';
import 'package:daepiro/data/model/request/set_mypage_profiles_request.dart';
import 'package:daepiro/data/model/response/mypage/get_mypage_address_response.dart';
import 'package:daepiro/domain/usecase/mypage/logout_usecase.dart';
import 'package:daepiro/domain/usecase/mypage/mypage_get_myarticles_usecase.dart';
import 'package:daepiro/domain/usecase/mypage/mypage_set_address_usecase.dart';
import 'package:daepiro/domain/usecase/mypage/mypage_set_profiles_usecase.dart';
import 'package:daepiro/domain/usecase/mypage/mypage_withdraw_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../data/model/request/set_mypage_address_notification_request.dart';
import '../../../data/model/request/withdraw_user_request.dart';
import '../../../data/model/response/mypage/get_mypage_articles_response.dart';
import '../../../domain/usecase/mypage/mypage_get_address_usecase.dart';
import '../../../domain/usecase/mypage/mypage_get_alarm_setting_usecase.dart';
import '../../../domain/usecase/mypage/mypage_get_announcement_usecase.dart';
import '../../../domain/usecase/mypage/mypage_get_announcements_usecase.dart';
import '../../../domain/usecase/mypage/mypage_get_disaster_type_usecase.dart';
import '../../../domain/usecase/mypage/mypage_get_profiles_usecase.dart';
import '../../../domain/usecase/mypage/mypage_set_alarm_setting_usecase.dart';
import '../../../domain/usecase/mypage/mypage_set_disaster_type_usecase.dart';
import '../../../domain/usecase/mypage/mypage_set_inquires_usecase.dart';
import '../../../domain/usecase/onboarding/check_nickname_usecase.dart';
import '../../../domain/usecase/onboarding/juso_result_usecase.dart';
import '../../../domain/usecase/onboarding/user_adresses_usecase.dart';
import '../../const/utils.dart';
import '../state/mypage_state.dart';

final myPageProvider =
    StateNotifierProvider<MyPageViewModel, MyPageState>((ref) {
  return MyPageViewModel(ref);
});

class MyPageViewModel extends StateNotifier<MyPageState> {
  final Ref ref;
  var _currentPage = 0;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Set<String> get inputJusoList => _inputJusoList;
  Set<String> _inputJusoList = Set<String>();

  MyPageViewModel(this.ref) : super(MyPageState()) {
    setPlatform();
  }

  void setLoadingState() {
    state = state.copyWith(isLoading: true);
    return;
  }

  void setPlatform() async {
    String platform = await storage.read(key: 'platform') ?? '';
    state = state.copyWith(platform: platform);
    return;
  }

  /// 프로필 정보 수정
  Future<void> getMyProfiles() async {
    final response = await ref
        .read(getProfilesUseCaseProvider(GetMyPageProfileUseCase()).future);
    state = state.copyWith(
        profileImgUrl: response.data?.profileImgUrl ?? '',
        realName: response.data?.realname ?? '',
        nickName: response.data?.nickname ?? '');
    return;
  }

  Future<void> setMyProfiles(String realName, String nickName) async {
    await ref.read(setProfilesUseCaseProvider(SetMyPageProfileUseCase(
        setMypageProfilesRequest: SetMyPageProfilesRequest(
      realname: realName,
      nickname: nickName,
    ))).future);
    return;
  }

  void setNameState(String name) {
    if (checkForNameRule(name)) {
      state =
          state.copyWith(nameState: '*이름은 한글로 입력해주세요.', completeSetName: false);
    } else if (name.length > 6) {
      state = state.copyWith(
          nameState: '*최대 6자까지 작성 가능해주세요.', completeSetName: false);
    } else if (name.length <= 6 && !checkForNameRule(name) && name != '') {
      state = state.copyWith(nameState: '', completeSetName: true);
    } else if (name == '') {
      state = state.copyWith(nameState: '', completeSetName: false);
    }
    return;
  }

  Future<void> setNickNameState(String nickName) async {
    if (nickName.length > 10) {
      state = state.copyWith(nicknameState: '*최대 10자까지 작성해주세요.', completeSetNickName: false);
    }

    if (!checkForSpecialCharacter(nickName)) {
      state = state.copyWith(nicknameState: '*닉네임은 한글/영문/숫자로 입력해주세요.', completeSetNickName: false);
    }

    if(nickName.length <= 10 && checkForSpecialCharacter(nickName)) {
      bool isAvailable = await _checkNickName(nickName);
      if (!isAvailable) {
        state = state.copyWith(
            nicknameState: nickName.isNotEmpty ? '*이미 사용 중인 닉네임이에요.' : '',
            completeSetNickName: false);
      } else {
        state = state.copyWith(nicknameState: '*사용 가능한 닉네임 입니다.', completeSetNickName: true);
      }
    }
    return;
  }

  Future<bool> _checkNickName(String nickname) async {
    final result = await ref.read(
        checkNickNameUseCaseProvider(CheckNickNameUseCase(nickName: nickname))
            .future);
    return result.data?.isAvailable ?? false;
  }

  void clearState() {
    state = state.copyWith(
      nameState: '',
      nicknameState: '',
      completeSetName: false,
      completeSetNickName: false
    );
    return;
  }

  /// 알람 정보 수정

  Future<void> getAlarmSettingType() async {
    bool status = await checknotificationPermission();
    if(!status) return;
    final response = await ref
        .read(getAlarmSettingUseCaseProvider(GetAlarmSettingUseCase()).future);
    state = state.copyWith(
        communityAlarmState: response.data?.isCommunityNotificationEnabled,
        disasterAlarmState: response.data?.isDisasterNotificationEnabled);
    return;
  }

  Future<void> setNotificationType(String type, bool isGrant) async {
    bool status = await checknotificationPermission();
    if (!status) {
      await openAppSettings();
      return;
    }
    await ref.read(
        setAlarmSettingUseCaseProvider(SetAlarmSettingUseCase(type: type))
            .future);
    await getAlarmSettingType();
    return;
  }

  Future<bool> checknotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      state = state.copyWith(
        communityAlarmState: false,
        disasterAlarmState: false,
      );
      return false;
    }
    return true;
  }

  /// 재난 지역에 대한 재설정

  //주소 검색 결과 초기화
  void initSearchHistory() {
    _inputJusoList = Set<String>();
  }

  Future<void> getAddressList() async {
    final response =
        await ref.read(getAddressUseCaseProvider(GetAddressUseCase()).future);
    List<MyAddresses> addressList = response.data?.addresses ?? [];
    for (int i = 0; i < addressList.length; i++) {
      if (addressList[i].name == '집') {
        state = state.copyWith(homeJuso: addressList[i].address ?? '');
      } else {
        if (state.firstJusoNick == '') {
          state = state.copyWith(
            firstJusoNick: addressList[i].name ?? '',
            firstJuso: addressList[i].address ?? '',
            isJuso1Visible: true,
            firstJusoState: 'Possible',
          );
        } else if (state.secondJusoNick == '') {
          state = state.copyWith(
            secondJusoNick: addressList[i].name ?? '',
            secondJuso: addressList[i].address ?? '',
            isJuso2Visible: true,
            secondJusoState: 'Possible',
          );
        }
      }
    }
    state = state.copyWith(isLoading: false);
  }

  void initErrorStateAddress() {
    state = state.copyWith(isError: false);
  }

  void setJusoNick(String firstNick, String secondNick) {
    state =
        state.copyWith(firstJusoNick: firstNick, secondJusoNick: secondNick);
  }

  List<Addresses> parseAddress() {
    List<Addresses> result = [];
    List<String> jusoNickName = [
      state.homeJusoNick,
      state.firstJusoNick,
      state.secondJusoNick
    ];
    List<String> address = [state.homeJuso, state.firstJuso, state.secondJuso];
    for (int i = 0; i < 3; i++) {
      if (jusoNickName[i] != '' && address[i] != '') {
        result.add(Addresses(name: jusoNickName[i], address: address[i]));
      }
    }
    return result;
  }

  Future<bool> setAddressList() async {
    try {
      final response = await ref.read(setAddressUseCaseProvider(
              SetAddressUseCase(
                  setMypageAddressNotificationRequest:
                      SetMypageAddressNotificationRequest(
                          addresses: parseAddress())))
          .future);
      if (response.code == 1000) {
        final userAddresses = await ref
            .read(userAddressUseCaseProvider(UserAddressUseCase()).future);
        for(int i=0; i<3; i++) {
          String? existingFullAddress = await storage.read(key: 'fullAddress_$i');
          String? existingShortAddress = await storage.read(key: 'shortAddress_$i');
          if (existingFullAddress != null) {
            await storage.delete(key: 'fullAddress_$i');
          }
          if (existingShortAddress != null) {
            await storage.delete(key: 'shortAddress_$i');
          }
        }
        if (userAddresses.length > 0) {
          for (int i = 0; i < userAddresses.length; i++) {
            await storage.write(
                key: 'fullAddress_$i', value: userAddresses[i].fullAddress);
            await storage.write(
                key: 'shortAddress_$i', value: userAddresses[i].shortAddress);
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void initUserAddress() {
    state = state.copyWith(
        firstJuso: '',
        secondJuso: '',
        firstJusoNick: '',
        secondJusoNick: '',
        isJuso1Visible: false,
        isJuso2Visible: false);
  }

  //지역 추가 칩 상태 업데이트를 위해
  bool checkPlusChipState(String homecontrollerText, String jusoController1Text,
      String jusoController2Text, bool juso1visible, bool juso2visible) {
    bool result = false;
    if (!juso1visible && !juso2visible && homecontrollerText.length > 1) {
      result = true;
    } else if (juso1visible && jusoController1Text.length > 1) {
      result = true;
    } else if (juso2visible && jusoController2Text.length > 1) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  void setVisibleState(int index, bool value) {
    if (index == 1) {
      state = state.copyWith(isJuso1Visible: value);
    } else {
      state = state.copyWith(isJuso2Visible: value);
    }
  }

  void addHomeJuso(String homeJuso) {
    state = state.copyWith(homeJuso: homeJuso);
  }

  void addFirstJuso(String firstJuso) {
    state = state.copyWith(firstJuso: firstJuso);
  }

  void addSecondJuso(String secondJuso) {
    state = state.copyWith(secondJuso: secondJuso);
  }

  void deleteHomeJuso() {
    state = state.copyWith(homeJuso: '');
  }

  void deleteFirstJuso() {
    state = state.copyWith(firstJuso: '', isJuso1Visible: false);
  }

  void deleteSecondJuso() {
    state = state.copyWith(secondJuso: '', isJuso2Visible: false);
  }

  //주소 별명 오류검증
  void checklocationControllerState(
      TextEditingController nickController, int index) {
    if (nickController.text.isEmpty) {
      if (index == 1) {
        state = state.copyWith(firstJusoState: '*별명은 필수로 입력해주세요.');
      } else {
        state = state.copyWith(secondJusoState: '*별명은 필수로 입력해주세요.');
      }
    } else if (nickController.text.length > 8) {
      if (index == 1) {
        state = state.copyWith(firstJusoState: '*최대 8자까지 작성해주세요.');
      } else {
        state = state.copyWith(secondJusoState: '*별명은 한글/영문/숫자로 입력해주세요.');
      }
    } else if (!checkForSpecialCharacter(nickController.text)) {
      if (index == 1) {
        state = state.copyWith(firstJusoState: '*별명은 한글/영문/숫자로 입력해주세요.');
      } else {
        state = state.copyWith(secondJusoState: '*별명은 한글/영문/숫자로 입력해주세요.');
      }
    } else {
      if (index == 1) {
        state = state.copyWith(firstJusoState: 'Possible');
      } else {
        state = state.copyWith(secondJusoState: 'Possible');
      }
    }
  }

  //검색결과 주소 리스트 반환
  Future<void> getJusoList(
      String inputJuso, int currentPage, bool append) async {
    final result = await ref.read(getJusoListUseCaseProvider(
        GetJusoListUseCase(inputJuso: inputJuso, currentPage: currentPage)).future);
    final currentList = _inputJusoList;
    try {
      final updateList = append ? currentList.union(result.toSet()) : result.toSet();
      _inputJusoList = updateList;
      state = state.copyWith(isError: false);
    } catch (e) {
      state = state.copyWith(isError: true);
    }
  }

  void controlJusoState(int index) {
    if(index == 1) {
      state = state.copyWith(
        firstJusoNick: '',
        firstJusoState: '',
        firstJuso: '',
        isJuso1Visible: false,
      );
    } else {
      state = state.copyWith(
        secondJusoNick: '',
        secondJusoState: '',
        secondJuso: '',
        isJuso2Visible: false,
      );
    }
  }

  /// 재난 유형 재설정

  Future<void> getDisasterType() async {
    final response = await ref
        .read(getDisasterTypeUseCaseProvider(GetDisasterTypeUseCase()).future);
    state =
        state.copyWith(disasterTypeList: response.data?.disasterTypes ?? []);
  }

  //재난 리스트 아이템 추가
  void addDisasterType(String disasterType) {
    final mutableList = List<String>.from(state.disasterTypeList);
    mutableList.add(disasterType);
    state = state.copyWith(disasterTypeList: List.unmodifiable(mutableList));
  }

  void removeDisasterType(String disasterType) {
    final mutableList = List<String>.from(state.disasterTypeList);
    mutableList.remove(disasterType);
    state = state.copyWith(disasterTypeList: List.unmodifiable(mutableList));
  }

  Future<bool> setDisasterType() async {
    try {
      final result = await ref.read(setDisasterTypeUseCaseProvider(
              SetDisasterTypeUseCase(
                  setMypageDisasterTypesRequest: SetMypageDisasterTypesRequest(
                      disasterTypes: state.disasterTypeList)))
          .future);
      if (result.code != 1000) {
        return false;
      } else {
        await getDisasterType();
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  /// 문의하기 설정

  void setInquireType(String type) {
    state = state.copyWith(inquireType: type);
  }

  Future<void> setInquires(String content, String email) async {
    await ref.read(setInquiresUseCaseProvider(SetInquiresUseCase(
            setMyPageInquiresRequest: SetMyPageInquiresRequest(
                type: InquireCategory.getNamedByCategory(state.inquireType),
                content: content,
                email: email)))
        .future);
  }

  /// 내가 쓴글 설정

  Future<void> getMyArticles() async {
    if (!state.isArticleHasMore) return;
    state = state.copyWith(isArticleLoading: true);
    final newPage = _currentPage + 1;
    final currentList = state.myArticles;
    try {
      final result = await ref.read(getMyArticlesUseCaseProvider(
              GetMyArticlesUseCase(page: newPage, size: 10))
          .future);
      final lastContent = result.data?.empty ?? false;
      if (lastContent) {
        state = state.copyWith(
          isArticleHasMore: false,
          isArticleLoading: false,
        );
        return;
      }
      final newContent = result.data?.content ?? [];
      _currentPage = newPage;
      state = state.copyWith(
        myArticles: List.from(currentList)..addAll(newContent),
        isArticleHasMore: true,
      );
    } catch (e) {
      print('마이페이지 내가쓴글 에러 발생 $e');
    } finally {
      state = state.copyWith(isArticleLoading: false);
    }
  }

  Future<void> reloadMyArticles() async {
    List<UserArticle> updateContentList = [];
    for (int i = 1; i <= _currentPage; i++) {
      final response = await ref.read(
          getMyArticlesUseCaseProvider(GetMyArticlesUseCase(page: i, size: 10))
              .future);
      updateContentList.addAll(response.data?.content ?? []);
    }
    state = state.copyWith(myArticles: updateContentList);
  }

  void initMyArticleState() async {
    _currentPage = 0;
    state = state.copyWith(
        myArticles: [], isArticleHasMore: true, isArticleLoading: true);
  }

  Future<void> logout() async {
    if (state.platform == 'kakao') {
      await UserApi.instance.logout();
    } else if (state.platform == 'naver') {
      await FlutterNaverLogin.logOut();
    }
    await ref.read(logoutUseCaseProvider(LogoutUsecase()).future);
    await storage.deleteAll();
  }

  ///공지사항
  //공지사항 리스트 조회
  Future<void> getAnnouncementList() async {
    print('여깅겨ㅣ');
    try {
      state = state.copyWith(isLoading: true);
      final response = await ref.read(
          getAnnouncementsUseCaseProvider(GetAnnouncementsUseCase()).future);
      state = state.copyWith(
          announcementList: response.data ?? [], isLoading: false);
    } catch (e) {
      print('공지사항을 불러올 수 없습니다. 다시 시도해주세요.');
      state = state.copyWith(announcementList: [], isLoading: false);
    }
  }

  //공지사항 단건 조회
  Future<void> getAnnouncementDetail(String id) async {
    try {
      final response = await ref.read(getAnnouncementDetailUseCaseProvider(
              GetAnnouncementDetailUseCase(id: id))
          .future);
      state = state.copyWith(
          announcementDetailResponse: response, isLoading: false);
    } catch (e) {
      print('공지사항을 불러올 수 없습니다. 다시 시도해주세요.');
      state =
          state.copyWith(announcementDetailResponse: null, isLoading: false);
    }
  }

  /// 회원탈퇴

  void setLeaveType(String value) async {
    state = state.copyWith(leaveType: value);
  }

  Future<void> deleteUserAccount() async {
    String platform = await storage.read(key: 'platform') ?? '';
    String? appleCode = null;
    if(platform == 'apple') {
      appleCode = await getAppleAuthorizeCode();
    }
    await ref.read(withDrawUseCaseProvider(
        WithDrawUseCase(
            reason: WithDrawReason.getNamedByCategory(state.leaveType).toLowerCase(),
            withDrawRequest: WithDrawRequest(appleCode: platform =='apple' ? appleCode : null)
        )).future);
    await storage.deleteAll();
  }

  Future<String> getAppleAuthorizeCode() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);
      return credential.authorizationCode;
    } catch (e) {
      print('애플 인가코드 로드중 error 발생 $e');
      return '';
    }
  }
}

enum InquireCategory {
  SERVICE('서비스 개선'),
  DISASTER('재난 알림 및 정보'),
  COMMUNITY('커뮤니티 이용'),
  ETC('기타');

  final String value;

  const InquireCategory(this.value);

  String getCategory() {
    switch (this) {
      case InquireCategory.SERVICE:
        return '서비스 개선';
      case InquireCategory.DISASTER:
        return '재난 알림 및 정보';
      case InquireCategory.COMMUNITY:
        return '커뮤니티 이용';
      default:
        return '기타';
    }
  }

  static String getByValue(String value) {
    return InquireCategory.values
        .firstWhere((el) => el.value == value)
        .getCategory();
  }

  static String getNamedByCategory(String category) {
    return InquireCategory.values
        .firstWhere((el) => el.getCategory() == category)
        .name;
  }
}

enum PlatformCategory {
  kakao('카카오 계정'),
  naver('네이버 계정'),
  apple('애플 계정'),
  other('');

  final String value;

  const PlatformCategory(this.value);

  static String getCategoryByKeyword(String keyword) {
    switch (keyword) {
      case 'kakao':
        return kakao.value;
      case 'naver':
        return naver.value;
      case 'apple':
        return apple.value;
      default:
        return other.value;
    }
  }
}

enum WithDrawReason {
  NEW('새 계정을 만들고 싶어요'),
  ALARM('알림이 너무 자주 와요'),
  INFO('정보가 부족해요'),
  USER('불편한 사람을 만났어요'),
  ETC('기타');

  final String value;

  const WithDrawReason(this.value);

  String getCategory() {
    switch (this) {
      case WithDrawReason.NEW:
        return '새 계정을 만들고 싶어요';
      case WithDrawReason.ALARM:
        return '알림이 너무 자주 와요';
      case WithDrawReason.INFO:
        return '정보가 부족해요';
      case WithDrawReason.USER:
        return '불편한 사람을 만났어요';
      default:
        return '기타';
    }
  }

  static String getNamedByCategory(String value) {
    return WithDrawReason.values
        .firstWhere((el) => el.value == value,
            orElse: () => WithDrawReason.ETC)
        .name;
  }
}
