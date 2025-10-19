import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gdgoc_com/screen/root_screen.dart';
import 'package:lottie/lottie.dart';
import '../vo/user.dart';
import 'main_screen.dart';

class JoinScreen4 extends StatefulWidget {
  const JoinScreen4({
    super.key,
    required this.user,
    required this.selectedAvatarPath,
    required this.selectedRegion,
    required this.selectedCampus,
    required this.selectedInterest,
  });

  final User user;
  final String selectedAvatarPath;
  final String selectedRegion;
  final String selectedCampus;
  final String selectedInterest;

  @override
  State<JoinScreen4> createState() => _JoinScreen4State();
}

class _JoinScreen4State extends State<JoinScreen4> {
  bool _agreeService = false;
  bool _agreePrivacy = false;
  bool _agreePush = false;
  bool _agreeEmail = false;
  bool _isLoading = false;

  bool get _allRequiredChecked => _agreeService && _agreePrivacy && _agreePush;

  Future<void> _completeJoin() async {
    setState(() => _isLoading = true);

    // 1~2초 동안 로딩 아이콘 표시
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    // ✅ User 데이터 통합
    final joinedUser = widget.user.copyWith(
      avatarPath: widget.selectedAvatarPath,
      region: widget.selectedRegion,
      campus: widget.selectedCampus,
      interest: widget.selectedInterest,
      agreeService: _agreeService,
      agreePrivacy: _agreePrivacy,
      agreePush: _agreePush,
      agreeEmail: _agreeEmail,
    );

    if (!mounted) return;
    await _showCompletionDialog(joinedUser);
  }

  /// ✅ 플랫폼별 팝업 자동 분기
  Future<void> _showCompletionDialog(User joinedUser) async {
    if (Platform.isIOS) {
      // iOS 기본 팝업
      await showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('알림'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('회원가입이 완료되었습니다.', style: TextStyle(fontSize: 14),),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RootScreen(user: joinedUser),
                  ),
                      (route) => false,
                );
              },
              child: const Text('확인', style: TextStyle(color: CupertinoColors.activeBlue),),
            ),
          ],
        ),
      );
    } else {
      // Android 및 기타 플랫폼 → Material AlertDialog
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('알림', textAlign: TextAlign.center),
          content: const Text('회원가입이 완료되었습니다.', textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 팝업 닫기
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MainScreen(user: joinedUser),
                  ),
                      (route) => false,
                );
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canNext = _allRequiredChecked;

    return Stack(
      children: [
        Scaffold(
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
                    '이용 약관에 동의해주세요',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 28),

                  // ✅ 필수 항목
                  _buildAgreementTile(
                    '서비스 이용 약관 동의 (필수)',
                    _agreeService,
                        (v) => setState(() => _agreeService = v),
                  ),
                  _buildAgreementTile(
                    '개인정보 처리방침 동의 (필수)',
                    _agreePrivacy,
                        (v) => setState(() => _agreePrivacy = v),
                  ),
                  _buildAgreementTile(
                    '앱 푸시 알림 동의 (필수)',
                    _agreePush,
                        (v) => setState(() => _agreePush = v),
                  ),
                  const Divider(height: 32),
                  // ✅ 선택 항목
                  _buildAgreementTile(
                    '이메일 알림 동의 (선택)',
                    _agreeEmail,
                        (v) => setState(() => _agreeEmail = v),
                  ),
                  const Spacer(),

                  // ✅ 완료 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: canNext ? _completeJoin : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canNext
                            ? const Color(0xFF26A865)
                            : const Color(0xFFE0E0E0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      child: const Text('완료'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ✅ 로딩 오버레이
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.4),
            alignment: Alignment.center,
            child: SizedBox(
              width: 120,
              height: 120,
              child: Lottie.asset(
                'assets/gdgoc_char/Design_Animation/loader.json',
                repeat: true,
                animate: true,
                frameRate: FrameRate.max, // 부드러운 재생
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAgreementTile(
      String title,
      bool value,
      ValueChanged<bool> onChanged,
      ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        value ? Icons.check_circle : Icons.circle_outlined,
        color: value ? const Color(0xFF26A865) : Colors.grey,
      ),
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      onTap: () => onChanged(!value),
    );
  }
}
