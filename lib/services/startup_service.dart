import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/startup_model.dart';
import 'api_config.dart';

class StartupService {
  Future<bool> createStartup(StartupModel startup) async {
    try {
      final headers = await ApiConfig.getHeaders();
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/startups/'),
        headers: headers,
        body: jsonEncode(startup.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['detail'] ?? 'Failed to create startup');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<StartupModel>> getStartups() async {
    try {
      final headers = await ApiConfig.getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/startups/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => StartupModel.fromJson(json)).toList();
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['detail'] ?? 'Failed to fetch startups');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<StartupModel>> getUserStartups(int userId) async {
    try {
      final headers = await ApiConfig.getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/startups/user/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => StartupModel.fromJson(json)).toList();
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['detail'] ?? 'Failed to fetch user startups');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
