import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../models/user_model.dart';

class UserService {
  Future<bool> submitOnboarding({
    required String bio,
    required List<String> interests,
    required List<String> skills,
    required bool hasExperience,
    String? projectName,
    String? experienceDescription,
    required String goal,
  }) async {
    try {
      final headers = await ApiConfig.getHeaders();
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/users/onboarding'),
        headers: headers,
        body: jsonEncode({
          'bio': bio,
          'interests': interests,
          'skills': skills,
          'has_experience': hasExperience,
          'project_name': projectName,
          'experience_description': experienceDescription,
          'goal': goal,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['detail'] ?? 'Failed to submit onboarding data');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<UserModel> fetchProfile() async {
    try {
      final headers = await ApiConfig.getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/users/me'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['detail'] ?? 'Failed to fetch profile');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<UserModel> fetchUserProfile(int userId) async {
    try {
      final headers = await ApiConfig.getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/users/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['detail'] ?? 'Failed to fetch user profile');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
