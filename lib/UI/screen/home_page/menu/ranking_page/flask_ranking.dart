import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ranking_screen.dart';

class RankingService {
  static Future<Map<String, dynamic>> fetchRankingData() async {
    final url = Uri.parse('http://112.184.197.77:5000/ranking');

    try {
      print('❓ [RankingService] 서버 요청 중... ➜ $url');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('✅ [RankingService] 서버 응답 성공');
        print('📦 응답 데이터: ${response.body}');

        final data = jsonDecode(response.body);

        final userList =
            (data['user'] is List ? data['user'] : [])
                .where((user) => user['score'] != null && user['score'] > 0)
                .map(
                  (user) => LeaderBoardItem(
                    name: user['name'],
                    penalty_days: (user['score'] as num).toInt(),
                    major: user['major'],
                  ),
                )
                .toList();

        final majorList =
            (data['majors'] is List ? data['majors'] : [])
                .map((major) => Map<String, dynamic>.from(major))
                .toList();

        return {'users': userList, 'majors': majorList};
      } else {
        print('❌ [RankingService] 서버 오류 상태 코드: ${response.statusCode}');
        print('🧾 오류 응답 본문: ${response.body}');
        return {'users': [], 'majors': []}; // 에러 시에도 빈 리스트 반환
      }
    } catch (e) {
      print('❌ [RankingService] 네트워크 예외 발생: $e');
      return {'users': [], 'majors': []}; // 예외 발생 시에도 빈 리스트 반환
    }
  }
}
