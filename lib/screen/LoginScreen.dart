import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // v7: 싱글턴
  final GoogleSignIn _signIn = GoogleSignIn.instance;

  // ✅ iOS/Web이면 clientId 지정 필요. (Android는 보통 null 가능)
  final String? _iOSClientId = dotenv.env['GOOGLE_CLIENT_ID'];
  final String? _serverClientId = null; // 백엔드 교환 쓰면 넣기

  // 중복 initialize 방지
  static bool _initialized = false;

  final List<String> _texts = const [
    "**GDGoC.com**은\nGDG on Campus\n멤버들을 위한 **공식 커뮤니티**입니다.",
    "캠퍼스를 넘어,\n**모든 개발자들이** 함께 소통하고\n성장할 수 있는 **열린 공간**입니다.",
    "최신 개발 행사와 지식,\n그리고 다양한 프로젝트 경험을\n**자유롭게 공유**할 수 있습니다.",
    "지금 바로 **GDGoC.com**에서\n**연결**되고, **배우고**, 함께 **성장**하세요."
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

    // ── GoogleSignIn v7 초기화 (이 파일 안에서 처리) ──
    if (!_initialized) {
      _initialized = true;
      unawaited(_signIn
          .initialize(
        clientId: defaultTargetPlatform == TargetPlatform.iOS ||
            kIsWeb
            ? _iOSClientId
            : null, // iOS/Web은 Client ID 필수
        serverClientId: _serverClientId,
      )
          .then((_) {
        _signIn.authenticationEvents
            .listen(_onAuthEvent)
            .onError((e) => debugPrint('GoogleSignIn error: $e'));
        // 이미 로그인된 계정이 있으면 조용히 복원 시도
        _signIn.attemptLightweightAuthentication();
      }));
    }

    // ─ 슬라이더 타이머 ─
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

  // 로그인/로그아웃 이벤트 수신
  Future<void> _onAuthEvent(GoogleSignInAuthenticationEvent e) async {
    final user = switch (e) {
      GoogleSignInAuthenticationEventSignIn() => e.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    if (user != null) {
      // ✅ 터미널 출력
      debugPrint('================ Google Account (v7) ================');
      debugPrint('id         : ${user.id}');
      debugPrint('email      : ${user.email}');
      debugPrint('displayName: ${user.displayName}');
      debugPrint('photoUrl   : ${user.photoUrl}');
      debugPrint('====================================================');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('환영해요, ${user.displayName ?? user.email}!')),
      );
    }
  }

  // 버튼 클릭 → 로그인
  Future<void> _signInPressed() async {
    try {
      if (_signIn.supportsAuthenticate()) {
        await _signIn.authenticate();
      } else {
        debugPrint('이 플랫폼은 authenticate() 미지원');
      }
    } catch (e) {
      debugPrint('구글 로그인 실패: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('로그인 실패: $e')));
    }
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
      color: const Color(0xFF000000),
      height: 1.35,
      fontWeight: FontWeight.w400,
    );
    final bold = base.copyWith(fontWeight: FontWeight.w700, fontSize: baseFontSize + 2);

    final parts = sentence.split('**');
    final spans = <TextSpan>[];
    for (var i = 0; i < parts.length; i++) {
      final chunk = parts[i];
      if (chunk.isEmpty) continue;
      spans.add(TextSpan(text: chunk, style: i.isOdd ? bold : base));
    }
    return RichText(textAlign: TextAlign.left, text: TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final widthScale = (w / 375.0).clamp(0.85, 1.25);
    final baseFontSize = (18.0 * widthScale).clamp(20.0, 22.0).toDouble();
    final groupMaxWidth = math.min(w - 32, 360.0);
    final buttonWidth = math.min(groupMaxWidth, 318.0);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: groupMaxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 이미지 + 텍스트
                SizedBox(
                  height: h * 0.50,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _images.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (_, i) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(child: Image.asset(_images[i], fit: BoxFit.contain)),
                          const SizedBox(height: 16),
                          _buildRichSentence(context, _texts[i], baseFontSize),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // 인디케이터(원형)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_images.length, (i) {
                    final active = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: active ? 10 : 8,
                      height: active ? 10 : 8, // ← 원형 점(기존 80은 오타)
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFF000000) : Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // 구글 로그인 버튼
                SizedBox(
                  width: buttonWidth,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _signInPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFFFF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
