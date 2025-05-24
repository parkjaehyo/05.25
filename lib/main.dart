import 'package:flutter/material.dart'; // Flutter의 UI 위젯 import
import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
// 다른 화면 파일 import
import 'UI/screen/home_page/menu/ranking_page/ranking_screen.dart'; // 양심 랭킹 화면
import 'UI/widget/left_side_info_menu.dart'; // 햄버거 메뉴(사이드 드로어)
import 'UI/screen/home_page/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'UI/screen/login_page/login_screen.dart';
import 'UI/screen/home_page/menu/RFID_page/nfc_auth_screen.dart';
import 'UI/screen/home_page/menu/map_page/map_screen.dart';
import 'UI/screen/home_page/menu/ranking_page/ranking_screen.dart';
import 'UI/screen/home_page/menu/report_page/report_screen.dart';
import 'service/alram_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase 초기화
  print('✅ Firebase 초기화 완료');

  //local db 연결
  /*
  try {
    await DatabaseHelper.connect(); // DB 연결 (로그는 내부에서 출력)
  } catch (_) {
    // 실패해도 앱은 계속 실행되게 유지
  }
    */
  try {
    await FCMService().init(); // 알람 서비스 함수 초기화
    print('✅ FCM 초기화 완료');
  } catch (e) {
    print('❌ FCM 초기화 실패: $e');
  }

  final flutterNaverMap = FlutterNaverMap(); // ✅ 인스턴스 생성
  await flutterNaverMap.init(
    clientId: '80v0v15qjo',
    onAuthFailed: (e) {
      print("네이버맵 인증 실패: $e");
    },
  );

  runApp(const MyApp()); // 앱 실행
}

// 앱 전체 구조 정의 (MaterialApp 포함)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShareU',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SplashScreen(), // 홈 화면으로 이동
    );
  }
}
