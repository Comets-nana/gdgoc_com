import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart'; // ✅ 한국어 날짜 초기화용
import 'package:gdgoc_com/screen/login_screen.dart';
import 'package:gdgoc_com/screen/root_screen.dart';
import '../vo/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ .env 로드
  await dotenv.load(fileName: ".env");

  // ✅ 한국어 로케일 초기화 (TableCalendar용)
  await initializeDateFormatting('ko_KR', null);

  // ✅ iOS / Android 시스템 영역 색상 통일
  if (Platform.isIOS) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));
  } else {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ 테스트용 유저 (로그인 연동 전용)
    final fakeUser = User(
      id: 'gildong@gmail.com',
      displayName: '홍길동',
      email: 'test@gdgoc.com',
      campus: '서울대학교',
      avatarPath: 'assets/gdgoc_char/Design_Profile/Red_Circle_profile.png',
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GDGoC.com',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF26A865)),
        useMaterial3: true,
      ),
      // ✅ RootScreen으로 바로 진입
      home: const Loginscreen(),
      routes: {
        '/loginscreen': (context) => const Loginscreen(),
        '/rootscreen': (context) => RootScreen(user: fakeUser),
      },
    );
  }
}