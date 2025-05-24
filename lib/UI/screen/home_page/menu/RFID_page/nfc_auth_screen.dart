import 'package:flutter/material.dart';

class NfcAuthScreen extends StatelessWidget {
  const NfcAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //flask 요청 코드(보내는 것 student_id(학번))
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2FB),
      appBar: AppBar(
        title: const Text(
          '강원대학교 학생증',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          padding: const EdgeInsets.symmetric(
            horizontal: 36,
            vertical: 44,
          ), // ⬅️ padding 소폭 증가
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32), // ⬅️ 더 둥글게
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '학부생(재학)',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 20, // ⬆️
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                '박재효',
                style: TextStyle(
                  fontSize: 34, // ⬆️
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '202020261',
                style: TextStyle(
                  fontSize: 22, // ⬆️
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '공학대학 AI소프트웨어학과',
                style: TextStyle(
                  fontSize: 18, // ⬆️
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 26),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 80, // ⬆️ 사진 약간 더 큼
                  backgroundImage: AssetImage('assets/jaehyo_photo.png'),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                '태그하세요',
                style: TextStyle(
                  fontSize: 20, // ⬆️
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              Image.asset('assets/knu_logo.png', height: 60), // ⬆️ 로고도 약간 확대
            ],
          ),
        ),
      ),
    );
  }
}
