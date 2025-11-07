import 'package:flutter/material.dart';

class StudyRecruitScreen extends StatefulWidget {
  const StudyRecruitScreen({super.key});

  @override
  State<StudyRecruitScreen> createState() => _StudyRecruitScreenState();
}

class _StudyRecruitScreenState extends State<StudyRecruitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
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
      body: SingleChildScrollView(),
    );
  }
}
