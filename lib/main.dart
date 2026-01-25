import 'dart:ui';
import 'package:audio_session/audio_session.dart';
import 'package:daepiro/conf/app_manager.dart';
import 'package:daepiro/route/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cmm/theme/DaepiroTheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppManager.instance.appInit();
  //await AppManager.instance.init('victoria'); /// 임시로 위치

  runApp(const ProviderScope(child: MyApp()));
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
