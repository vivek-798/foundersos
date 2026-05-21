import 'token_service.dart';

class ApiConfig {
  // Use 10.0.2.2 for Android Emulators, or 127.0.0.1 for physical devices with adb reverse
  static const String baseUrl = "http://10.0.2.2:8000/api/v1";

  static Future<Map<String, String>> getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = await TokenService.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}
