// 화면이름_표시위젯_의도

abstract class AppResources {
  /// 네비게이션
  static const MainNavigation_homeLabel = '홈';
  static const MainNavigation_communityLabel = '커뮤니티';
  static const MainNavigation_informationLabel = '재난정보';
  static const MainNavigation_fundingLabel = '후원';
  static const MainNavigation_mypageLabel = '마이페이지';

  static const jusoInput_Message_SearchResult = '검색결과';
  static const jusoInput_Message_guide = ' 어디인가요?';
  static const jusoInput_ErrorMessage_InvalidAddress = '올바르지 않은 주소예요';
  static const jusoInput_ErrorMessage_RetrySearch = '동/읍/면/리 주소로 다시 검색해주세요.';
  static const jusoInput_HintText_hintType = '동/읍/면/리';

  /// 예외처리 리소스
  static const ApiException_Default = '대피로 관리자에게 문의하세요.';
  static const ApiException_invalidAuthentication = '로그인 인증 정보가 올바르지 않습니다. 다시 시도해주세요.';
  static const ApiException_networkTimeout =  '네트워크 연결이 실패';
  static const ApiException_networkOff = '와이파이 확인';
  static const ApiException_invalidServerInfo = '서버 오류가 발생했습니다. 넘버원 서버팀에 문의해주세요.';
}