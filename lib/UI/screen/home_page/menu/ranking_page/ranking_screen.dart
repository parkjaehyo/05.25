import 'dart:convert';
import 'package:flutter/material.dart';
import 'flask_ranking.dart'; // ← RankingService를 여기서 import 해야 함

class LeaderBoardItem {
  final String name;
  final int penalty_days;
  final String major;

  LeaderBoardItem({
    required this.name,
    required this.penalty_days,
    required this.major,
  });
}

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<LeaderBoardItem> items = [];
  final List<Map<String, dynamic>> _majorRanking = [];

  @override
  void initState() {
    super.initState();
    RankingService.fetchRankingData()
        .then((data) {
          setState(() {
            items = List<LeaderBoardItem>.from(data['users']);
            _majorRanking
              ..clear()
              ..addAll(
                (data['majors'] as List).map(
                  (e) => Map<String, dynamic>.from(e),
                ),
              );
          });
        })
        .catchError((error) {
          print("❌ 랭킹 데이터 불러오기 실패: $error");
        });
  }

  @override
  Widget build(BuildContext context) {
    final top3 = items.take(3).toList();
    final rest = items.skip(3).toList();
    final majorRankings = _majorRanking;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("양심 랭킹")),
      body:
          items.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFC107), Color(0xFFFFD54F)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildTopUser(top3.length > 1 ? top3[1] : null, rank: 2),
                        buildTopUser(
                          top3.isNotEmpty ? top3[0] : null,
                          rank: 1,
                          isCenter: true,
                        ),
                        buildTopUser(top3.length > 2 ? top3[2] : null, rank: 3),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          ...rest.asMap().entries.map((entry) {
                            final rank = entry.key + 4;
                            return buildRankTile(entry.value, rank);
                          }),
                          const Divider(thickness: 1.5),
                          const SizedBox(height: 12),
                          const Text(
                            "📚 학과별 양심 랭킹 (평균 연체 기준)",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...majorRankings.asMap().entries.map((entry) {
                            final rank = entry.key + 1;
                            final major = entry.value['major'];
                            final avg = double.parse(
                              entry.value['avg'].toString(),
                            );
                            final rankEmoji = ['🥇', '🥈', '🥉'];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      child: Text(
                                        rank <= 3
                                            ? rankEmoji[rank - 1]
                                            : '$rank',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        major,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '-${avg.toStringAsFixed(1)}일',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget buildTopUser(
    LeaderBoardItem? user, {
    required int rank,
    bool isCenter = false,
  }) {
    if (user == null) return const SizedBox.shrink();
    final double size = isCenter ? 80 : 65;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CircleAvatar(
              radius: size / 2,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: size / 2 - 4,
                backgroundColor: Colors.red.shade700,
                child: Text(
                  user.name.substring(0, 2),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          user.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          user.major,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          '-${user.penalty_days}일',
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ],
    );
  }

  Widget buildRankTile(LeaderBoardItem user, int rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 16,
              child: Text(
                '$rank',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    user.major,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Text(
              '-${user.penalty_days}일',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
