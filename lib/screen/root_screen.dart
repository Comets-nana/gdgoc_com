import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../vo/user.dart';
import 'main_screen.dart';
import 'menu_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key, required this.user});
  final User user;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  int _nowIndex = 0;
  late final List<Widget> _screens;

  // ✅ QR 관련 상태
  int _seconds = 10;
  Timer? _timer;
  String _qrData = '';
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _screens = [
      MainScreen(user: widget.user),
      const SizedBox.shrink(),
      const MenuScreen(),
    ];

    _qrData = _generateNewQR();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  String _getCampusCode(String? campusName) {
    if (campusName == null) return 'Campus';
    switch (campusName) {
      case '동의대학교':
        return 'DEU';
      case '부산대학교':
        return 'PNU';
      case '서울대학교':
        return 'SNU';
      case '경북대학교':
        return 'KNU';
      case '계명대학교':
        return 'GMU';
      case '부경대학교':
        return 'PKNU';
      case '동아대학교':
        return 'DAU';
      case '연세대학교':
        return 'YONSEI';
      default:
      // 모르는 캠퍼스는 전체 이름 표시
        return campusName;
    }
  }


  // ✅ QR 데이터 새로 생성
  String _generateNewQR() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'GDGoC_${widget.user.email ?? 'unknown'}_$timestamp';
  }

  // ✅ QR 갱신 함수 (자동 & 수동 둘 다 사용)
  void _refreshQR({bool userTriggered = false}) {
    setState(() {
      _rotationController.forward(from: 0); // 회전 시작
      _qrData = _generateNewQR(); // 새 QR 코드
      _seconds = 10; // 카운트다운 초기화
    });

    if (userTriggered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR 코드가 새로고침되었습니다 ✅')),
      );
    }
  }

  // ✅ 카운트다운 시작
  void _startCountdown() {
    _timer?.cancel();
    _seconds = 10;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _rotationController.forward(from: 0);
          _qrData = _generateNewQR();
          _seconds = 10;
        }
      });
    });
  }

  void _showIDCardModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.37,
          minChildSize: 0.37,
          maxChildSize: 0.37,
          expand: false,
          builder: (_, controller) {
            return StreamBuilder<int>(
              // ✅ 1초마다 rebuild — 외부 _seconds 값과 무관하게 반영됨
              stream: Stream.periodic(const Duration(seconds: 1), (_) => _seconds)
                  .asBroadcastStream(),
              builder: (context, snapshot) {
                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'ID Card',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 🔹 프로필 + QR코드
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              CustomPaint(
                                painter: MultiColorCirclePainter(),
                                child: const CircleAvatar(
                                  backgroundImage: AssetImage(
                                    'assets/gdgoc_char/Design_Profile/Red_Circle_profile.png',
                                  ),
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                widget.user.displayName ?? 'OOO',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'GDGoC ${_getCampusCode(widget.user.campus)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 40),

                          // ✅ QR코드 + 타이머
                          Transform.translate(
                            offset: const Offset(20, -10),
                            child: Column(
                              children: [
                                QrImageView(
                                  data: _qrData,
                                  version: QrVersions.auto,
                                  size: 160,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      // ✅ snapshot.data로 매초 반영
                                      '00:${_seconds.toString().padLeft(2, '0')}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black54),
                                    ),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: () => _refreshQR(userTriggered: true),
                                      child: AnimatedBuilder(
                                        animation: _rotationController,
                                        builder: (_, child) {
                                          return Transform.rotate(
                                            angle: _rotationController.value *
                                                6.28319, // 360도
                                            child: child,
                                          );
                                        },
                                        child: const Icon(
                                          Icons.refresh,
                                          size: 18,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _nowIndex,
        children: _screens,
      ),



      // ✅ 하단바 (Home, Menu만)
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: BottomAppBar(
            color: Colors.white,
            elevation: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ✅ 왼쪽: Home
                _buildBottomItem(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  isSelected: _nowIndex == 0,
                  onTap: () => setState(() => _nowIndex = 0),
                ),

                // ✅ 중앙: 원형 ID 버튼
                GestureDetector(
                  onTap: () => _showIDCardModal(context),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFF26A865),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.badge_rounded,
                        color: Colors.white, size: 32),
                  ),
                ),

                // ✅ 오른쪽: Menu
                _buildBottomItem(
                  icon: Icons.menu_rounded,
                  label: 'Menu',
                  isSelected: _nowIndex == 2,
                  onTap: () => setState(() => _nowIndex = 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildBottomItem({
  required IconData icon,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 28,
          color: isSelected ? const Color(0xFF000000) : Colors.grey,
        ),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF000000) : Colors.grey,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

class MultiColorCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 4.0;
    const radius = 60 + strokeWidth / 2; // CircleAvatar 반지름 + 테두리 반

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // ✅ 네 구간 색상 정의
    final colors = [
      Colors.green, // 위쪽
      Colors.yellow, // 오른쪽
      Colors.blue, // 아래쪽
      Colors.red, // 왼쪽
    ];

    // ✅ 각 색상 구간별로 90도(π/2 라디안)씩 그림
    double startAngle = -90 * 3.1415926535 / 180; // 위쪽부터 시작
    for (final color in colors) {
      paint.color = color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        3.1415926535 / 2, // 90도
        false,
        paint,
      );
      startAngle += 3.1415926535 / 2;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

