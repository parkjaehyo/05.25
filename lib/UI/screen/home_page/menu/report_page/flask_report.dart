import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportService {
  static Future<bool> submitReport({
    required String userId,
    required String title,
    required String content,
  }) async {
    final url = Uri.parse('http://112.184.197.77:5000/report');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'title': title,
          'content': content,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ 신고 성공');
        return true;
      } else {
        print('❌ 신고 실패: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ 네트워크 오류: $e');
      return false;
    }
  }
}
