import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../widget/left_side_info_menu.dart';
import 'menu/ranking_page/ranking_screen.dart';
import 'menu/RFID_page/nfc_auth_screen.dart';
import 'menu/report_page/report_screen.dart';
import 'menu/map_page/map_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../login_page/flask_login.dart';
import 'flask_user_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _imageController = PageController();

  final List<String> imageUrls = [
    'https://wwwk.kangwon.ac.kr/site/campusmap/images/contents/samcheok/init_map_img.png',
    'https://cdn.kado.net/news/photo/200710/337099_81678_1642.jpg',
    'https://dormitory.kangwon.ac.kr/bbs/view_image.php?bo_table=4_1&fn=169153634_aHSwLcRb_c06654f43a80f4d7d3e529c04e4e8a4cf8836147.jpg',
  ];

  String name = ''; // 🔥 사용자 이름 추가
  int couponCount = 0;
  String borrowDay = '';
  String preReturnDay = '';
  bool isLate = false;
  int remainTimeMinutes = 0;
  String statusMessage = '';
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    final data = await fetchUserInfo();
    if (data != null) {
      setState(() {
        name = data['name'] ?? ''; // 🔥 사용자 이름 업데이트
        couponCount = data['coupon_count'] ?? 0;
        borrowDay = data['borrow_day'] ?? '';
        preReturnDay = data['pre_return_day'] ?? '';
        isLate = data['is_late'] ?? false;
        remainTimeMinutes = data['remain_time_minutes'] ?? 0;
        statusMessage = data['status'] ?? '';

        int maxday = 3;
        int currentday = maxday - (remainTimeMinutes.abs() ~/ (24 * 60));
        if (currentday < 0) currentday = 0;
        progress = (currentday / maxday).clamp(0.0, 1.0);
      });
    } else {
      print('❌ 데이터 수신 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildSideDrawer(context),
      appBar: AppBar(
        title: const Text('ShareU'),
        centerTitle: true,
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _imageController,
                itemCount: imageUrls.length,
                itemBuilder: (_, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(imageUrls[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SmoothPageIndicator(
              controller: _imageController,
              count: imageUrls.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.amber,
              ),
            ),
            const SizedBox(height: 16),
            buildPointStatusCard(),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  buildCard(
                    context: context,
                    title: "대여소 찾기",
                    icon: Icons.map,
                    page: const MapScreen(),
                  ),
                  buildCard(
                    context: context,
                    title: "대여/반납",
                    icon: Icons.qr_code_scanner,
                    page: const NfcAuthScreen(),
                  ),
                  buildCard(
                    context: context,
                    title: "이용내역 확인",
                    icon: Icons.receipt_long,
                  ),
                  buildCard(
                    context: context,
                    title: "공지사항",
                    icon: Icons.campaign,
                  ),
                  buildCard(
                    context: context,
                    title: "양심 랭킹",
                    icon: Icons.emoji_events,
                    page: const RankingScreen(),
                  ),
                  buildCard(
                    context: context,
                    title: "신고하기",
                    icon: Icons.support_agent,
                    page: const ReportScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPointStatusCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔥 사용자 이름 적용
                      Text(
                        name.isNotEmpty ? "$name님의 대여 상태" : "사용자님의 대여 상태",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        isLate ? "연체 상태 🚨" : "남은 대여 시간 🚀",
                        style: TextStyle(
                          fontSize: 13,
                          color: isLate ? Colors.red : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isLate ? Colors.red : Colors.green,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isLate
                            ? "연체 ${remainTimeMinutes.abs()}분"
                            : statusMessage,
                        style: TextStyle(
                          fontSize: 12,
                          color: isLate ? Colors.red[700] : Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 12,
            child: Row(
              children: [
                const Text(
                  'coupon',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.card_giftcard, size: 18, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '$couponCount',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    Widget? page,
  }) {
    return GestureDetector(
      onTap: () {
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        }
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.green[800]),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
