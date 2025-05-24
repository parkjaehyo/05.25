import 'dart:convert';
import 'package:http/http.dart' as http;

class UmbrellaService {
  static Future<Map<String, dynamic>?> fetchUmbrellaStatus(
    int locationId,
  ) async {
    final url = Uri.parse(
      'http://112.184.197.77:5000/current_umbrella?location_id=$locationId',
    );
    try {
      print('❓ 서버 요청 중...'); // 로깅 추가
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('✅ 서버 응답: ${response.body}'); // 로깅 추가
        return jsonDecode(response.body);
      } else {
        print('❌ 서버 오류: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ 네트워크 오류: $e');
      return null;
    }
  }
}
