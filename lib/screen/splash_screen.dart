import 'package:flutter/material.dart';
import 'package:gdgoc_com/screen/login_screen.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Loginscreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Figma 배경색
      body: SizedBox.expand( // ✅ 화면 전체 크기
        child: Lottie.asset(
          'assets/animations/splash_screen_prototype.json',
          fit: BoxFit.cover, // ✅ 전체화면에 맞게 확대/자르기
          repeat: false, // 한 번만 재생
        ),
      ),
    );
  }
}
