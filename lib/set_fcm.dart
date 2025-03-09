
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SettingFCM {
  final _localNotifications = FlutterLocalNotificationsPlugin();

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('백그라운드 메시지 처리: ${message.notification?.title}');
  }

  Future<void> initNotification() async {
    //백그라운드 메시지 핸들러 등록
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    //로컬 알림 초기화
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(
        settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
          print('알림 클릭!!!!!');
      }
    );

    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    final androidImplementation =
    _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.createNotificationChannel(androidChannel);

    // Foreground 알림 설정
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground 메시지 처리
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Map<String, dynamic> notification = message.data;
      String title = notification.isEmpty ? message.notification!.title : notification['title'];
      String body = notification.isEmpty ? message.notification!.body : notification['body'];
      print('알림 notification: $title');
      print('알림 notification: $body');

      if(Platform.isAndroid) {
        _localNotifications.show(
          notification.hashCode,
          title,
          body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(sound: 'default'),
          ),
        );
      }
        });
  }
}