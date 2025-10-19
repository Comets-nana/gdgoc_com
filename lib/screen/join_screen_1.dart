import 'package:flutter/material.dart';
import '../vo/user.dart';          // ← User DTO 가져오기
import 'join_screen_2.dart';

class JoinScreen1 extends StatefulWidget {
  const JoinScreen1({
    super.key,
    required this.user,           // ← 로그인에서 넘어온 사용자 상태 유지
  });

  final User user;

  @override
  State<JoinScreen1> createState() => _JoinScreen1State();
}

class _JoinScreen1State extends State<JoinScreen1> {
  // 프로젝트의 실제 에셋 경로 사용
  final List<String> _avatars = const [
    'assets/gdgoc_char/Design_Profile/Red_Circle_profile.png',
    'assets/gdgoc_char/Design_Profile/Yellow_Circle_profile.png',
    'assets/gdgoc_char/Design_Profile/Green_Circle_profile.png',
    'assets/gdgoc_char/Design_Profile/Blue_Circle_profile.png',
  ];

  int? _selected; // 선택된 인덱스 기억

  @override
  Widget build(BuildContext context) {
    final bool canNext = _selected != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '프로필을 선택해주세요',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 24),
              // 2 x 2 그리드
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(), // 스크롤 없음
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: _avatars.length,
                  itemBuilder: (context, i) {
                    final bool isSelected = _selected == i;
                    final bool shouldDim =
                        _selected != null && _selected != i; // 선택되면 나머지 흐리게

                    return GestureDetector(
                      onTap: () => setState(() => _selected = i),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 150),
                            opacity: shouldDim ? 0.5 : 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFFFFFFF),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF26A865) // 선택 테두리(초록)
                                      : const Color(0xFFE5E5E5),
                                  width: 2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x11000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: ClipOval(
                                  child: Image.asset(
                                    _avatars[i],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Positioned(
                              top: -4,
                              right: -4,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Color(0xFF26A865),
                                child: Icon(Icons.check,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              // 다음 버튼
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: canNext
                      ? () {
                    final selectedPath = _avatars[_selected!];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JoinScreen2(
                          user: widget.user,                 // ← 사용자 상태 유지
                          selectedAvatarPath: selectedPath,  // ← 선택 프로필 전달
                        ),
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    canNext ? const Color(0xFF26A865) : const Color(0xFFE0E0E0),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  child: const Text('다음'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
