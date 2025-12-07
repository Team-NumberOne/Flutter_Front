import 'package:daepiro/data/model/request/set_fcm_request.dart';
import 'package:daepiro/data/model/request/social_login_request.dart';
import 'package:daepiro/domain/usecase/login/set_fcm_token_usecase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../data/model/response/login/sociallogin_token_response.dart';
import '../../domain/usecase/login/social_login_usecase.dart';
import '../../domain/usecase/onboarding/user_adresses_usecase.dart';
import 'login_state.dart';

final loginStateNotifierProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel(ref);
});

class LoginViewModel extends StateNotifier<LoginState> {
  final Ref ref;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  List<Permission> permission = [
    Permission.location,
    Permission.notification,
    Permission.camera,
    Permission.storage
  ];

  LoginViewModel(this.ref) : super(LoginState());

  Future<SocialLoginTokenResponse?> fetchSocialToken(String platform, String token) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await ref.read(getSocialTokenUsecaseProvider(
              GetSocialTokenUseCase(
                  platform: platform,
                  tokenRequest: SocialLoginRequest(socialToken: token)))
          .future);
      if(response.code != 1000) {
        throw Exception("Invalid response code: ${response}");
      } else {
        state = state.copyWith(
            isLoading: false,
            isCompletedOnboarding: response.data?.isCompletedOnboarding ?? false,
            isLoginSuccess: true);
        await storage.write(key: 'accessToken', value: response.data?.accessToken);
        await storage.write(key: 'refreshToken', value: response.data?.refreshToken);
        await storage.write(key: 'platform', value: platform);
      }
    } catch (error) {
      print('토큰 저장 오류: $error');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> setFcmToken() async {
    String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
    ref.read(setFcmTokenUseCaseProvider(
        SetFcmTokenUseCase(setFcmRequest: SetFcmRequest(
            fcmToken: fcmToken
        ))
    ));
  }

  Future<void> storeUserAdresses() async {
    try {
      final userAddresses =
      await ref.read(userAddressUseCaseProvider(UserAddressUseCase()).future);
      if (userAddresses.length > 0) {
        for (int i = 0; i < userAddresses.length; i++) {
          await storage.write(
              key: 'fullAddress_$i', value: userAddresses[i].fullAddress);
          await storage.write(
              key: 'shortAddress_$i', value: userAddresses[i].shortAddress);
        }
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<void> kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
        await fetchSocialToken('kakao', token.accessToken);
      } catch (error) {
        print('카카오톡으로 로그인 실패: $error');
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          await fetchSocialToken('kakao', token.accessToken);
        } catch (error) {
          print('카카오계정으로 로그인 실패: $error');
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        await fetchSocialToken('kakao', token.accessToken);
      } catch (error) {
        print('카카오계정으로 로그인 실패: $error');
      }
    }
    return;
  }

  Future<void> naverLogin() async {
    try {
      await FlutterNaverLogin.logIn();
      final naverAccessToken = await FlutterNaverLogin.getCurrentAccessToken();
      await fetchSocialToken('naver', naverAccessToken.accessToken);
    } catch (error) {
      print('네이버 로그인 에러: $error');
    }
    return;
  }

  Future<void> appleLogin() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: []);
      await fetchSocialToken('apple', credential.authorizationCode ?? '');
    } catch (e) {
      print('애플로그인 시도중 error 발생 $e');
      return;
    }
  }

  Future<bool> checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> requestLocationPermission() async {
    await Permission.location.request();
  }
}
