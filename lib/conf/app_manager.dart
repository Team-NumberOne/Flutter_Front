import 'package:daepiro/cmm/logger.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../presentation/const/string_helper.dart';

class AppManager {
  final DaepiroLogger _logger = DaepiroLogger.instance;

  static final AppManager instance = AppManager._();
  AppManager._();

  /// 초기화 수행여부
  bool _isInitialized = false;


  // 로그인 이후 호출
  Future<void> init(String userId) async {
    if(_isInitialized) return;

    _isInitialized = true;
    _initFirebaseSetting(userId);
  }

  Future<void> appInit() async {
    await StringHelper.initialize();
    /// 카카오 sdk 초기화
    await dotenv.load(fileName: ".env");
    String nativeKakaoKey = dotenv.get('KAKAOKEY');
    KakaoSdk.init(nativeAppKey: nativeKakaoKey);

    /// 네이버 로그인, 지도 sdk 초기화
    String naverMapKey = dotenv.get('NAVER_MAP_CLIENTID');
    // await NaverMapSdk.instance.initialize(
    //   clientId: naverMapKey,
    //   onAuthFailed: (e) => print("네이버맵 인증 오류:$e")
    // );

  }

 // 로그인을 완료한 사용자에 한해서 crasy 리포트에 기록한다
  // 로그인 완료 후 호출
  Future<void> _initFirebaseSetting(String userId) async {
    try {
      final firebaseApp = await Firebase.initializeApp();
      final crashlytics = FirebaseCrashlytics.instance;
      final analytics = FirebaseAnalytics.instanceFor(app: firebaseApp);
      await crashlytics.setUserIdentifier(userId);
      _logger.updateFirebaseComponent(crashlytics: crashlytics, analytics: analytics);
    } catch(error, stackTrace) {
      _logger.e(error.toString(), error: error, stackTrace: stackTrace);
    }
  }


}

