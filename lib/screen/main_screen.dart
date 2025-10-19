import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../vo/user.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.user});
  final User user;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _selectedCampus = '';
  bool _isLoading = false;

  final List<String> _campuses = [
    '경북대학교',
    '계명대학교',
    '고려대학교',
    '동아대학교',
    '동의대학교',
    '부산대학교',
    '서울대학교',
    '연세대학교'
  ];

  @override
  void initState() {
    super.initState();
    _selectedCampus = widget.user.campus ?? '동의대학교';
    if (!_campuses.contains(_selectedCampus)) {
      _selectedCampus = _campuses.first;
    }
  }

  // ✅ 캠퍼스 변경 시 로딩 효과
  void _changeCampus(String newValue) {
    setState(() {
      _selectedCampus = newValue;
      _isLoading = true;
    });

    // 2초 후 실제 데이터 표시
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('로그아웃')),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Loginscreen()),
            (route) => false,
      );
    }
  }

  void _showCupertinoPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 280,
        color: Colors.white,
        child: Column(
          children: [
            // ✅ 상단 완료 버튼
            Container(
              color: const Color(0xFFF7F7F7),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      '완료',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController:
                FixedExtentScrollController(initialItem: _campuses.indexOf(_selectedCampus)),
                magnification: 1.1,
                itemExtent: 44,
                onSelectedItemChanged: (index) {
                  _changeCampus(_campuses[index]);
                },
                children: _campuses
                    .map(
                      (campus) => Center(
                    child: Text(
                      campus,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        widget.user.displayName ?? widget.user.email?.split('@').first ?? '사용자';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 상단 로고 + 로그아웃
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/gdgoc_logo.png',
                    height: 40,
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, color: Colors.black),
                    tooltip: '로그아웃',
                    onPressed: () => _logout(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 환영 문구
              Text(
                '환영합니다, $userName 님',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // 🔹 캠퍼스 선택
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '현재 캠퍼스:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 10),
                  Platform.isIOS
                      ? GestureDetector(
                    onTap: () => _showCupertinoPicker(context),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFF26A865),
                            width: 2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedCampus,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF26A865),
                            ),
                          ),
                          const SizedBox(width: 80),
                        ],
                      ),
                    ),
                  )
                      : DropdownButton<String>(
                    value: _campuses.contains(_selectedCampus)
                        ? _selectedCampus
                        : _campuses.first,
                    underline: Container(
                      height: 2,
                      color: const Color(0xFF26A865),
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF26A865),
                    ),
                    items: _campuses
                        .map(
                          (campus) =>
                          DropdownMenuItem(value: campus, child: Text(campus)),
                    )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCampus = value);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 🔸 섹션들
              _buildSectionCard('나의 예정 이벤트'),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _isLoading
                    ? _buildSkeletonLoader()
                    : Column(
                  key: ValueKey(_selectedCampus),
                  children: [
                    _buildSectionCard('모집 / 이벤트 배너 (${_selectedCampus})',
                        subText: '(이미지 슬라이드)'),
                    _buildSectionCard('스터디 모집 리스트 (${_selectedCampus})'),
                    _buildSectionCard('다가오는 이벤트 (${_selectedCampus})'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔸 공용 카드 위젯
  Widget _buildSectionCard(String title, {String? subText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            if (subText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(subText,
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ),
            const SizedBox(height: 12),
            Container(
              height: 90,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Column(
      key: const ValueKey('skeleton'),
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }),
    );
  }
}
