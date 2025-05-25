import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../login_page/flask_login.dart'; // login_id import 확인

class ReportService {
  static Future<bool> submitReport({
    required String title,
    required String content,
  }) async {
    final url = Uri.parse('http://112.184.197.77:5000/report');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': login_id, // 학번 전달
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
