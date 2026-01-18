import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

class DaepiroLogger extends Logger {

  FirebaseCrashlytics? _crashlytics;
  FirebaseAnalytics? _analytics;

  static final DaepiroLogger instance = DaepiroLogger._();
  DaepiroLogger._();

  @override
  void i(
      dynamic message, {
        DateTime? time,
        Object? error,
        Map? additional,
        StackTrace? stackTrace,
      }) {
    super.i(message.toString(), error: error, stackTrace: stackTrace);
  }

  @override
  void d(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    super.d(message.toString(), error: error, stackTrace: stackTrace);
  }

  @override
  void e(
      dynamic message, {
        DateTime? time,
        Object? error,
        StackTrace? stackTrace,
      }) {
    super.e(message.toString(), error: error, stackTrace: stackTrace);
    _crashlytics?.recordError(error, stackTrace, reason: message.toString());
  }

  /// crashlitics를 위한 전용 함수
  void recordError(dynamic error, StackTrace stackTrace) {
    super.e(stackTrace.toString(), error: error, stackTrace: stackTrace);
    _crashlytics?.recordError(error, stackTrace);
  }
}

extension FMLoggerExtForFirebase on DaepiroLogger {
  void updateFirebaseComponent({FirebaseCrashlytics? crashlytics, FirebaseAnalytics? analytics}) {
    _crashlytics = crashlytics;
    _analytics = analytics;
  }

  /// Crashlytics를 통해 오류 발생시 내용을 기록한다.
  void recordError(dynamic error, StackTrace stackTrace) {
    _crashlytics?.recordError(error, stackTrace);
  }

  void recordLog(String value) {
    _crashlytics?.log(value);
  }

  void recordAdditionalInfo({required String key, required String value}) {
    d('[$key Record Additional Info] $value');
    _crashlytics?.setCustomKey(key, value);
  }

  /// [FirebaseAnalytics]
  /// 이벤트를 기록한다.
  /// 앱에서 정의한 [FirebaseAnalyticsEventType] 에 추가된 이벤트만 추가한다.
  void recordEvent(FirebaseAnalyticsEvent event) {
    _analytics?.logEvent(name: event.eventName, parameters: event.parameters);
  }

  /// [FirebaseAnalytics]
  /// 이벤트를 기록한다.
  /// 앱에서 정의한 [FirebaseAnalyticsEventType] 에 추가된 이벤트만 추가한다.
  void recordScreenView(String screenName, {Map<String, Object>? parameters}) {
    _analytics?.logScreenView(screenName: screenName, parameters: parameters);
  }
}

abstract class FirebaseAnalyticsEvent {
  final String eventName;
  final Map<String, Object>? parameters;

  FirebaseAnalyticsEvent({required this.eventName, this.parameters});
}
