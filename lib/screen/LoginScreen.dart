import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<String> _texts = const [
    "**GDGoC.com**은\nGDG on Campus\n멤버들을 위한 **공식 커뮤니티**입니다.",
    "캠퍼스를 넘어,\n**모든 개발자들이** 함께 소통하고\n성장할 수 있는 **열린 공간**입니다.",
    "최신 개발 행사와 지식,\n그리고 다양한 프로젝트 경험을\n**자유롭게 공유**할 수 있습니다.      ",
    "지금 바로 **GDGoC.com**에서\n**연결**되고, **배우고**, 함께 **성장**하세요.          "
  ];

  final List<String> _images = const [
    "assets/gdgoc_char/Design_Illuster/LoginScreen_Illuster_1.png",
    "assets/gdgoc_char/Design_Illuster/LoginScreen_Illuster_2.png",
    "assets/gdgoc_char/Design_Illuster/LoginScreen_Illuster_3.png",
    "assets/gdgoc_char/Design_Illuster/LoginScreen_Illuster_4.png",
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _currentPage = (_currentPage + 1) % _images.length;
      if (mounted) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildRichSentence(BuildContext context, String sentence, double baseFontSize) {
    final base = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: baseFontSize,
      color: Color(0xFF000000),
      height: 1.35,
      fontWeight: FontWeight.w400,
    );
    final bold = base.copyWith(fontWeight: FontWeight.w700, fontSize: baseFontSize + 2);

    final spans = <TextSpan>[];
    final parts = sentence.split('**');
    for (int i = 0; i < parts.length; i++) {
      final chunk = parts[i];
      if (chunk.isEmpty) continue;
      spans.add(TextSpan(text: chunk, style: i.isOdd ? bold : base));
    }

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final widthScale = (w / 375.0).clamp(0.85, 1.25);
    final baseFontSize = (18.0 * widthScale).clamp(16.0, 22.0);
    final groupMaxWidth = math.min(w - 32, 360.0);
    final buttonWidth = math.min(groupMaxWidth, 318.0);

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: groupMaxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ❗️ 내용 크기만큼만 차지
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── 이미지 + 텍스트 ──
                SizedBox(
                  height: h * 0.45, // 화면의 45%를 이미지+텍스트로 사용
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _images.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (_, i) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.asset(
                              _images[i],
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildRichSentence(context, _texts[i], baseFontSize),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // ── 인디케이터 ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_images.length, (i) {
                    final active = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active ? Color(0xFF000000) : Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // ── 구글 로그인 버튼 ──
                SizedBox(
                  width: buttonWidth,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFFFFF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/google_logo.png", height: 22),
                        const SizedBox(width: 12),
                        const Text(
                          "Google 계정으로 로그인",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
