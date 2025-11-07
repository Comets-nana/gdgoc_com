import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../vo/user.dart';
import 'join_screen_3.dart';

class JoinScreen2 extends StatefulWidget {
  const JoinScreen2({
    super.key,
    required this.user,
    required this.selectedAvatarPath,
  });

  final User user;
  final String selectedAvatarPath;

  @override
  State<JoinScreen2> createState() => _JoinScreen2State();
}

class _JoinScreen2State extends State<JoinScreen2> {
  String? _selectedRegion;
  String? _selectedCampus;

  // 🔹 지역 및 캠퍼스 데이터
  final Map<String, List<String>> _campusMap = {
    '서울': ['캠퍼스 선택', '서울대학교', '연세대학교', '고려대학교'],
    '부산': ['캠퍼스 선택', '동의대학교', '부산대학교', '동아대학교'],
    '대구': ['캠퍼스 선택', '경북대학교', '계명대학교'],
  };

  final List<String> _regions = ['지역 선택', '서울', '부산', '대구'];

  // ✅ iOS용 피커
  void _showCupertinoPicker({
    required List<String> items,
    required Function(String) onSelected,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 280,
        color: Color(0xffffffff),
        child: Column(
          children: [
            // 상단 완료 버튼 (기본 iOS 스타일)
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
            // 실제 피커
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
    // ✅ 버튼 활성화 조건
    final bool canNext = _selectedRegion != null &&
        _selectedCampus != null &&
        _selectedRegion != '지역 선택' &&
        _selectedCampus != '캠퍼스 선택';

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffffffff),
        foregroundColor: Color(0xff000000),
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
                '어느 소속에 해당되나요?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 32),

              // 🌍 지역 선택
              Platform.isIOS
                  ? GestureDetector(
                onTap: () {
                  _showCupertinoPicker(
                    items: _regions,
                    onSelected: (value) {
                      setState(() {
                        if (value == '지역 선택') {
                          _selectedRegion = null;
                          _selectedCampus = null;
                        } else {
                          _selectedRegion = value;
                          _selectedCampus = null;
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
                        color: _selectedRegion == null
                            ? const Color(0xFFE0E0E0)
                            : const Color(0xFF26A865),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Text(
                    _selectedRegion ?? '지역 선택',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: _selectedRegion == null
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                ),
              )
                  : SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  value: _selectedRegion ?? '지역 선택',
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: _selectedRegion == null
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
                  items: _regions
                      .map(
                        (region) => DropdownMenuItem(
                      value: region,
                      child: Text(
                        region,
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
                      if (value == '지역 선택') {
                        _selectedRegion = null;
                        _selectedCampus = null;
                      } else {
                        _selectedRegion = value;
                        _selectedCampus = null;
                      }
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 🎓 캠퍼스 선택 (지역이 선택된 경우에만 표시)
              if (_selectedRegion != null) ...[
                Platform.isIOS
                    ? GestureDetector(
                  onTap: () {
                    _showCupertinoPicker(
                      items: _campusMap[_selectedRegion] ?? [],
                      onSelected: (value) {
                        setState(() {
                          if (value == '캠퍼스 선택') {
                            _selectedCampus = null;
                          } else {
                            _selectedCampus = value;
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
                          color: _selectedCampus == null
                              ? const Color(0xFFE0E0E0)
                              : const Color(0xFF26A865),
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Text(
                      _selectedCampus ?? '캠퍼스 선택',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: _selectedCampus == null
                            ? Colors.grey
                            : Colors.black87,
                      ),
                    ),
                  ),
                )
                    : SizedBox(
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    value: _selectedCampus ?? '캠퍼스 선택',
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: _selectedCampus == null
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
                    items: (_campusMap[_selectedRegion] ?? [])
                        .map(
                          (campus) => DropdownMenuItem(
                        value: campus,
                        child: Text(
                          campus,
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
                        if (value == '캠퍼스 선택') {
                          _selectedCampus = null;
                        } else {
                          _selectedCampus = value;
                        }
                      });
                    },
                  ),
                ),
              ],

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
                        builder: (_) => JoinScreen3(
                          user: widget.user,
                          selectedAvatarPath:
                          widget.selectedAvatarPath,
                          selectedRegion: _selectedRegion!,
                          selectedCampus: _selectedCampus!,
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
