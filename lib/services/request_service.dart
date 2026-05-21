import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../models/user_model.dart';

class JoinRequestModel {
  final int id;
  final int startupId;
  final String startupTitle;
  final int requesterId;
  final UserModel requester;
  final String status; // pending, accepted, rejected
  final String? message;
  final DateTime createdAt;
  final DateTime updatedAt;

  JoinRequestModel({
    required this.id,
    required this.startupId,
    required this.startupTitle,
    required this.requesterId,
    required this.requester,
    required this.status,
    this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JoinRequestModel.fromJson(Map<String, dynamic> json) {
    return JoinRequestModel(
      id: json['id'],
      startupId: json['startup_id'],
      startupTitle: json['startup_title'] ?? '',
      requesterId: json['requester_id'],
      requester: UserModel.fromJson(json['requester']),
      status: json['status'] ?? 'pending',
      message: json['message'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }
}

class RequestService {
  Future<bool> sendJoinRequest(int startupId, String message) async {
    try {
      final headers = await ApiConfig.getHeaders();
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/startups/request'),
        headers: headers,
        body: jsonEncode({
          'startup_id': startupId,
          'message': message,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['detail'] ?? 'Failed to send request');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<JoinRequestModel>> fetchIncomingRequests() async {
    try {
      final headers = await ApiConfig.getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/startups/requests'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => JoinRequestModel.fromJson(json)).toList();
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['detail'] ?? 'Failed to fetch incoming requests');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<bool> acceptRequest(int requestId) async {
    try {
      final headers = await ApiConfig.getHeaders();
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/startups/requests/$requestId/accept'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['detail'] ?? 'Failed to accept request');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<bool> rejectRequest(int requestId) async {
    try {
      final headers = await ApiConfig.getHeaders();
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/startups/requests/$requestId/reject'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['detail'] ?? 'Failed to reject request');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<Map<int, String>> fetchSentRequestsMap() async {
    try {
      final headers = await ApiConfig.getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/startups/my-requests'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data.map((key, value) => MapEntry(int.parse(key), value as String));
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['detail'] ?? 'Failed to fetch sent requests status');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
