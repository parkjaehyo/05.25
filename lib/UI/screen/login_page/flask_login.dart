import 'dart:convert';
import 'package:http/http.dart' as http;

// 전역 변수 선언
String? login_id;

class UserService {
  static Future<Map<String, dynamic>?> login(
    String studentId,
    String password,
  ) async {
    final url = Uri.parse('http://112.184.197.77:5000/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'student_id': studentId, 'password': password}),
      );

      print('서버 응답 코드: ${response.statusCode}');
      print('서버 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['student_id'] != null) {
          print('✅ 로그인 성공: ${data['student_id']} - ${data['name']}');
          login_id = studentId; // 전역 변수에 로그인 ID 저장
          return data;
        } else {
          print('❌ 응답은 200 OK지만 student_id가 없음: $data');
          return null;
        }
      } else {
        final errorData = jsonDecode(response.body);
        print('❌ 로그인 실패: ${errorData['error']}');
        return null;
      }
    } catch (e) {
      print('❌ 네트워크 오류: $e');
      return null;
    }
  }
}
