import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../vo/user.dart';
import 'join_screen_4.dart';

class JoinScreen3 extends StatefulWidget {
  const JoinScreen3({
    super.key,
    required this.user,
    required this.selectedAvatarPath,
    required this.selectedRegion,
    required this.selectedCampus,
  });

  final User user;
  final String selectedAvatarPath;
  final String selectedRegion;
  final String selectedCampus;

  @override
  State<JoinScreen3> createState() => _JoinScreen3State();
}

class _JoinScreen3State extends State<JoinScreen3> {
  String? _selectedInterest;

  // 🔹 관심 분야 목록
  final List<String> _interests = const [
    '관심 분야 선택',
    'Mobile',
    'Web',
    'AI/ML',
    'Cloud',
    'Game',
    'Security',
    'IoT/Embedded',
  ];

  // 🔹 iOS용 피커
  void _showCupertinoPicker({
    required List<String> items,
    required Function(String) onSelected,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 280,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: const Color(0xFFF7F7F7),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                magnification: 1.1,
                itemExtent: 44,
                onSelectedItemChanged: (index) {
                  onSelected(items[index]);
                },
                children: items
                    .map(
                      (item) => Center(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
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
    final bool canNext =
        _selectedInterest != null && _selectedInterest != '관심 분야 선택';

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
                '관심 분야는 어디인가요?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 32),

              Platform.isIOS
                  ? GestureDetector(
                onTap: () {
                  _showCupertinoPicker(
                    items: _interests,
                    onSelected: (value) {
                      setState(() {
                        if (value == '관심 분야 선택') {
                          _selectedInterest = null;
                        } else {
                          _selectedInterest = value;
                        }
                      });
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _selectedInterest == null
                            ? const Color(0xFFE0E0E0)
                            : const Color(0xFF26A865),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Text(
                    _selectedInterest ?? '관심 분야 선택',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: _selectedInterest == null
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                ),
              )
                  : SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  value: _selectedInterest ?? '관심 분야 선택',
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: _selectedInterest == null
                            ? const Color(0xFFE0E0E0)
                            : const Color(0xFF26A865),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFF26A865), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 12),
                  ),
                  items: _interests
                      .map(
                        (interest) => DropdownMenuItem(
                      value: interest,
                      child: Text(
                        interest,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      if (value == '관심 분야 선택') {
                        _selectedInterest = null;
                      } else {
                        _selectedInterest = value;
                      }
                    });
                  },
                ),
              ),

              const Spacer(),

              // ✅ 다음 버튼
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: canNext
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JoinScreen4(
                          user: widget.user,
                          selectedAvatarPath:
                          widget.selectedAvatarPath,
                          selectedRegion: widget.selectedRegion,
                          selectedCampus: widget.selectedCampus,
                          selectedInterest: _selectedInterest!,
                        ),
                      ),
                    );
                  }
                      : null,
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
