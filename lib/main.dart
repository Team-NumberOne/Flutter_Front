import 'package:audio_session/audio_session.dart';
import 'package:daepiro/presentation/const/string_helper.dart';
import 'package:daepiro/route/router.dart';
import 'package:daepiro/set_fcm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'cmm/theme/DaepiroTheme.dart';
import 'data/model/local_db/behavior_tip/behavior_adapter.dart';
import 'data/model/local_db/behavior_tip/tip_item_adapter.dart';
import 'data/model/local_db/behavior_tip/tips_adapter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  String nativeKakaoKey = dotenv.get('KAKAOKEY');

  await StringHelper.initialize();

  //소셜 로그인 초기화
  KakaoSdk.init(nativeAppKey: nativeKakaoKey);
  await _naverInit();

  await Firebase.initializeApp();
  await SettingFCM().initNotification();
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // String? token = await messaging.getToken();
  // print("FCM 토큰: $token");
  // hive db 초기화
  await _hiveInit();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _hiveInit() async {
  await Hive.initFlutter();

  Hive.registerAdapter(TipItemAdapter());
  Hive.registerAdapter(TipsAdapter());
  Hive.registerAdapter(BehaviorAdapter());

  await Hive.openBox<String>('behaviorTipsBox');
}

Future<void> _naverInit() async {
  await dotenv.load(fileName: ".env");
  String naverMapKey = dotenv.get('NAVER_MAP_CLIENTID');
  // await NaverMapSdk.instance.initialize(
  //   clientId: naverMapKey,
  //   onAuthFailed: (e) => print("네이버맵 인증 오류:$e")
  // );
  return;
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initAudioSession();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    await _initAudioSession();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouteProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: DaepiroColorStyle.white,
      ),
    );
  }
}
