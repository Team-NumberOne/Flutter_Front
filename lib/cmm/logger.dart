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

  void recordEvent(FirebaseAnalyticsEvent event) {
    _analytics?.logEvent(name: event.eventName, parameters: event.parameters);
  }


  void recordScreenView(String screenName, {Map<String, Object>? parameters}) {
    _analytics?.logScreenView(screenName: screenName, parameters: parameters);
  }
}

abstract class FirebaseAnalyticsEvent {
  final String eventName;
  final Map<String, Object>? parameters;

  FirebaseAnalyticsEvent({required this.eventName, this.parameters});
}
