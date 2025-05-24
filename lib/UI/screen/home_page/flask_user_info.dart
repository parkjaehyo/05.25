import 'dart:convert';
import 'package:http/http.dart' as http;
import '../login_page/flask_login.dart'; // login_id 전역 변수 import

Future<Map<String, dynamic>?> fetchUserInfo() async {
  /*if (login_id == null) {
    print('❌ 로그인 ID 없음. 로그인 후 시도하세요.');
    return null;
  }*/

  // Flask 서버 URL에 login_id(student_id)를 쿼리 파라미터로 포함
  final url = Uri.parse(
    'http://112.184.197.77:5000/user_info?student_id=$login_id',
  );

  try {
    final response = await http.get(url);

    print('서버 응답 코드: ${response.statusCode}');
    print('서버 응답 본문: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // JSON 데이터 반환
    } else {
      final errorData = jsonDecode(response.body);
      print('❌ 오류: ${errorData['error']}');
      return null;
    }
  } catch (e) {
    print('❌ 네트워크 오류: $e');
    return null;
  }
}
