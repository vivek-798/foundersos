import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'token_service.dart';

class AuthService {
  Future<bool> signup(String email, String password, String fullName) async {
    try {
      final headers = await ApiConfig.getHeaders();
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/signup'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'password': password,
          'full_name': fullName,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        if (token != null) {
          await TokenService.saveToken(token);
        }
        return true;
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['detail'] ?? 'Signup failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final headers = await ApiConfig.getHeaders();
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        if (token != null) {
          await TokenService.saveToken(token);
        }
        return true;
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['detail'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<void> logout() async {
    await TokenService.deleteToken();
  }
}
