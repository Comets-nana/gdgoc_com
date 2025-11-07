import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgoc_com/screen/study_detail_screen.dart';
import 'package:gdgoc_com/screen/study_recruit_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import '../vo/user.dart';
import 'event_detail_screen.dart';
import 'login_screen.dart';
import 'notice_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.user});
  final User user;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _selectedCampus = '';
  bool _isLoading = false;

  String _calcDDayLabel(DateTime eventDate) {
    // 날짜만 남기기 (시간 제거)
    final today = DateTime.now();
    final dToday = DateTime(today.year, today.month, today.day);
    final dEvent = DateTime(eventDate.year, eventDate.month, eventDate.day);

    final diff = dEvent.difference(dToday).inDays;

    if (diff == 0) return 'D-day';
    if (diff > 0)  return 'D-$diff';
    return 'D+${diff.abs()}';
  }


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
    final confirm = await (Platform.isIOS
        ? showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('로그아웃'),
        content: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            '정말 로그아웃하시겠습니까?',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: false,
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              '취소',
              style: TextStyle(color: CupertinoColors.black),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              '로그아웃',
              style: TextStyle(color: CupertinoColors.destructiveRed),
            ),
          ),
        ],
      ),
    )
        : showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          '로그아웃',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          '정말 로그아웃하시겠습니까?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              '취소',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              '로그아웃',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    ));

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
              _buildMyEventCard(),
              const SizedBox(height: 10),
              _buildUpdateCarousel(),
              const SizedBox(height: 20),
              _buildStudyRecruitCard(context),
              const SizedBox(height: 20),
              _buildEventCalendarCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyEventSkeleton() {
    return Container(
      key: const ValueKey('eventSkeleton'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 8,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 140,
            height: 18,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 14,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 200,
                      height: 14,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyEventCard() {
    // ✅ 더미 이벤트 날짜
    final eventDate = DateTime(2025, 11, 8);
    final dDayLabel = _calcDDayLabel(eventDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _isLoading
            ? _buildMyEventSkeleton() // ✅ 스켈레톤 카드
            : Container(
          key: const ValueKey('eventCard'),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 제목 + D-day
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '나의 예정 이벤트',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFF4CAF50), width: 1.2),
                    ),
                    child: Text(
                      dDayLabel, // ✅ 자동 계산된 D-day
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 🔹 이벤트 정보
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/images/event_default_image.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '홍길동',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff6c6c6c),
                                ),
                              ),
                              TextSpan(
                                text: '  |  ',
                                style: TextStyle(
                                  color: Color(0xff6c6c6c),
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: '9월 정기세션',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff6c6c6c),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '발표자 세션/테크 토크',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: '  |  ',
                                style: TextStyle(
                                  color: Color(0xff6c6c6c),
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: '산학 415',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 버튼
              SizedBox(
                width: double.infinity,
                height: 34,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EventDetailScreen(),
                        settings: RouteSettings(arguments: {
                          'title': '발표자 세션/테크 토크',
                          'host': '홍길동',
                          'place': '산학 415',
                          'description': 'GDG 정기세션에서 최신 Flutter 기술과 사례를 공유합니다.',
                        }),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '자세히 보기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateCarouselSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 타이틀
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
          child: Container(
            width: 180,
            height: 20,
            color: Colors.grey.shade300,
          ),
        ),

        // 카드 본문 (하얀색 + 그림자)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          height: 140,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.grey.shade300,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateCarousel() {
    final List<String> _images = [
      'assets/images/event_default_image.png',
      'assets/images/event_default_image.png',
      'assets/images/event_default_image.png',
      'assets/images/event_default_image.png',
      'assets/images/event_default_image.png',
    ];

    final PageController _pageController = PageController();
    bool _isPlaying = true;
    int _currentPage = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        // 자동 슬라이드 로직
        Future.delayed(const Duration(seconds: 5), () {
          if (!_isPlaying) return;
          if (!mounted) return;
          final nextPage = (_currentPage + 1) % _images.length;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _isLoading
              ? _buildUpdateCarouselSkeleton() // ✅ 로딩 시 스켈레톤 표시
              : Column(
            key: const ValueKey('updateCarousel'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 카드 바깥의 타이틀
              // 🔹 카드 바깥의 타이틀
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4, right: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '새로운 업데이트 소식',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NoticeScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        '더보기 >',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff6c6c6c),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 하얀색 카드 (이미지 슬라이드)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 140,
                        width: double.infinity,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _images.length,
                          onPageChanged: (index) {
                            setState(() => _currentPage = index);
                          },
                          itemBuilder: (context, index) {
                            return Image.asset(
                              _images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                        ),
                      ),

                      // 🔹 오버레이 (정지 버튼 + 페이지 표시)
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() => _isPlaying = !_isPlaying);
                                },
                                child: Icon(
                                  _isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${_currentPage + 1} / ${_images.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildStudyRecruitSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 제목 스켈레톤
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
          child: Container(
            width: 160,
            height: 20,
            color: Colors.grey.shade300,
          ),
        ),

        // 🔹 카드 스켈레톤
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 🔹 왼쪽 (아이콘 + 스터디명 자리)
                    Row(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 100,
                          height: 14,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),

                    // 🔹 오른쪽 (스터디장 + 마감일 자리)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 80,
                          height: 12,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 70,
                          height: 12,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildStudyRecruitCard(BuildContext context) {
    // ✅ 더미 데이터
    final List<Map<String, String>> _studyList = [
      {
        'icon': '👨‍💻',
        'name': 'Flutter 스터디',
        'leader': '홍길동',
        'deadline': '2025.11.07',
      },
      {
        'icon': '🤖',
        'name': 'AI Vision 팀스터디',
        'leader': '김철수',
        'deadline': '2025.11.10',
      },
      {
        'icon': '📱',
        'name': 'Android 입문',
        'leader': '박민수',
        'deadline': '2025.11.12',
      },
      {
        'icon': '💡',
        'name': '창업 아이디어 스터디',
        'leader': '이영희',
        'deadline': '2025.11.15',
      },
      {
        'icon': '🧠',
        'name': 'ML 논문 스터디',
        'leader': '정우성',
        'deadline': '2025.11.20',
      },
    ];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: _isLoading
          ? _buildStudyRecruitSkeleton() // ✅ 로딩 시 스켈레톤 표시
          : Column(
        key: const ValueKey('studyRecruit'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 제목 + 더보기
          Padding(
            padding:
            const EdgeInsets.only(left: 4, bottom: 8, top: 4, right: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '스터디 모집 리스트',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StudyRecruitScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    '더보기 >',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff6c6c6c),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 카드 (리스트 포함)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 8,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: _studyList.map((study) {
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            StudyDetailScreen(studyData: study),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 🔹 왼쪽 (이모지 + 스터디 이름)
                        Row(
                          children: [
                            Text(study['icon']!,
                                style: const TextStyle(fontSize: 22)),
                            const SizedBox(width: 10),
                            Text(
                              study['name']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        // 🔹 오른쪽 (스터디장 + 마감일)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '스터디장: ${study['leader']}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${study['deadline']} 마감',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
          child: Container(
            width: 140,
            height: 20,
            color: Colors.grey.shade300,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          height: 320,
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: List.generate(6, (_) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (_) {
                    return Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCalendarCard() {
    // ✅ 이벤트 더미 데이터
    final Map<DateTime, List<Map<String, String>>> eventSource = {
      DateTime(2025, 11, 6): [
        {'title': 'Flutter 세션', 'place': '산학 415', 'host': '홍길동'},
      ],
      DateTime(2025, 11, 20): [
        {'title': 'AI 세미나', 'place': '공대 301', 'host': '김철수'},
        {'title': '스터디 네트워킹', 'place': '도서관 3층', 'host': '이영희'},
      ],
      DateTime(2025, 12, 4): [
        {'title': '정기 Meetup', 'place': '산학 503', 'host': '박민수'},
      ],
    };

    // ✅ 법정 공휴일 데이터
    final Map<DateTime, String> holidays = {
      DateTime(2025, 1, 1): '신정',
      DateTime(2025, 3, 1): '삼일절',
      DateTime(2025, 5, 5): '어린이날',
      DateTime(2025, 6, 6): '현충일',
      DateTime(2025, 8, 15): '광복절',
      DateTime(2025, 9, 7): '추석',
      DateTime(2025, 9, 8): '추석 연휴',
      DateTime(2025, 9, 9): '추석 연휴',
      DateTime(2025, 10, 3): '개천절',
      DateTime(2025, 10, 9): '한글날',
      DateTime(2025, 12, 25): '성탄절',
    };

    DateTime _focusedDay = DateTime.now();
    DateTime _selectedDay = DateTime.now();

    DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

    List<Map<String, String>> _selectedEvents =
        eventSource[_normalize(_selectedDay)] ?? [];

    String? _selectedHoliday = holidays[_normalize(_selectedDay)];

    return StatefulBuilder(
      builder: (context, setState) {
        List<Map<String, String>> _getEventsForDay(DateTime day) {
          return eventSource[_normalize(day)] ?? [];
        }

        bool _isHoliday(DateTime day) => holidays.containsKey(_normalize(day));

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _isLoading
              ? _buildCalendarSkeleton()
              : Column(
            key: const ValueKey('eventCalendar'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8, top: 4),
                child: Text(
                  '이벤트 캘린더',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),

              // ✅ 카드 전체
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 🗓️ 캘린더
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TableCalendar<Map<String, String>>(
                        locale: 'ko_KR',
                        focusedDay: _focusedDay,
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          weekendStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color:
                            const Color(0xFF4CAF50).withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                          weekendTextStyle:
                          const TextStyle(color: Colors.redAccent),
                          outsideDaysVisible: false,
                          markerDecoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                          markersMaxCount: 2,
                        ),
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, day, events) {
                            final hasEvents = events.isNotEmpty;
                            final isHoliday = _isHoliday(day);
                            if (!hasEvents && !isHoliday) {
                              return const SizedBox();
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (hasEvents)
                                  Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.only(
                                        top: 30, right: 1),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4CAF50),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                if (isHoliday)
                                  Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.only(
                                        top: 30, left: 1),
                                    decoration: const BoxDecoration(
                                      color: Colors.redAccent,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            );
                          },
                          defaultBuilder: (context, day, focusedDay) {
                            final isHoliday = _isHoliday(day);
                            return Center(
                              child: Text(
                                '${day.day}',
                                style: TextStyle(
                                  color: isHoliday
                                      ? Colors.redAccent
                                      : Colors.black,
                                  fontWeight: isHoliday
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        ),
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            _selectedEvents =
                                _getEventsForDay(selectedDay);
                            _selectedHoliday =
                            holidays[_normalize(selectedDay)];
                          });
                        },
                        eventLoader: _getEventsForDay,
                      ),
                    ),

                    // ✅ 경계선
                    Container(height: 1, color: Colors.grey[300]),

                    // ✅ 선택한 날짜 이벤트 표시
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_selectedHoliday != null)
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.flag,
                                      color: Colors.redAccent, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    _selectedHoliday!,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (_selectedEvents.isEmpty &&
                              _selectedHoliday == null)
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(
                                  '예정된 이벤트가 없습니다',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          if (_selectedEvents.isNotEmpty)
                            ..._selectedEvents.map((event) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const EventDetailScreen(),
                                      settings: RouteSettings(arguments: event),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event['title'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${event['host']} | ${event['place']}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                        color: Colors.black45,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
