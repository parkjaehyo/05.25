// lib/services/fcm_service.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FCMService {
  late FirebaseMessaging _messaging;

  /// 🔹 Firebase 및 FCM 초기화
  ///
  Future<void> init() async {
    _messaging = FirebaseMessaging.instance;

    await _requestPermission();
    await _initLocalNotification(); // ✅ 로컬 알림 초기화
    _getToken();
    _foregroundListener();
    _backgroundHandler();
  }

  /// 🔹 알림 권한 요청 (Android 13 이상)
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission();
    print("🔔 알림 권한 상태: ${settings.authorizationStatus}");
  }

  /// 🔹 로컬 알림 플러그인 초기화
  Future<void> _initLocalNotification() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  /// 🔹 디바이스 FCM 토큰 출력
  void _getToken() async {
    final token = await _messaging.getToken();
    print("✅ FCM Token: $token");
  }

  /// 🔹 포그라운드 수신 처리 + 시스템 알림 표시
  void _foregroundListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      if (notification != null) {
        print("📥 [포그라운드 수신] ${notification.title}");

        await flutterLocalNotificationsPlugin.show(
          0,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'fcm_default_channel',
              'FCM 알림',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🟢 [알림 클릭됨] ${message.notification?.title}");
    });
  }

  /// 🔹 백그라운드 핸들러 등록
  void _backgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

/// 🔹 앱이 완전히 꺼진 상태에서 푸시 받을 때 실행되는 백그라운드 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔴 [백그라운드 메시지] ID: ${message.messageId}");
}
