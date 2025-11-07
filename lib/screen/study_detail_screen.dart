import 'package:flutter/material.dart';

class StudyDetailScreen extends StatefulWidget {
  final Map<String, String> studyData; // ✅ 스터디 데이터 전달받기

  const StudyDetailScreen({super.key, required this.studyData});

  @override
  State<StudyDetailScreen> createState() => _StudyDetailScreenState();
}

class _StudyDetailScreenState extends State<StudyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final study = widget.studyData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          study['name'] ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ✅ 본문
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 대표 아이콘
            Center(
              child: Text(
                study['icon'] ?? '📘',
                style: const TextStyle(fontSize: 60),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 기본 정보
            Text(
              study['name'] ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '스터디장: ${study['leader']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '모집 마감일: ${study['deadline']}',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // 🔹 소개 섹션
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              '스터디 소개',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '이 스터디는 ${study['name']} 관련 주제를 함께 학습하고 성장하기 위해 만들어졌습니다. '
                  '스터디장 ${study['leader']}님이 진행하며, ${study['deadline']}까지 참가 신청을 받습니다.',
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // 🔹 참가 버튼
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('스터디 참가 신청이 완료되었습니다!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26A865),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '스터디 참가 신청하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}