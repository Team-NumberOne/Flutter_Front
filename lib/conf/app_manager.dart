import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '../set_fcm.dart';

class AppManager {
  static final AppManager instance = AppManager._();
  AppManager._();

  /// 초기화 수행여부
  bool _isInitialized = false;


  Future<void> init() async {
    if(_isInitialized) return;

    _isInitialized = true;
    await _initFirebaseSetting();
  }

  Future<void> _initFirebaseSetting() async {
    await Firebase.initializeApp();
    await SettingFCM().initNotification();
    _setCrashlyticsSetting();
  }

  void _setCrashlyticsSetting() {
    FlutterError.onError =
        FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

}

