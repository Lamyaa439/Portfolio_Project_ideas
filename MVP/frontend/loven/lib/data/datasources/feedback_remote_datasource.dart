import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/network/api_constants.dart';
import '../../core/storage/token_storage.dart';

class FeedbackRemoteDataSource {
  final TokenStorage _tokenStorage = TokenStorage();

  Future<Map<String, dynamic>> submitFeedback({
    required String message,
    String? subject,
  }) async {
    final token = await _tokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }

    final response = await http.post(
      Uri.parse(ApiConstants.feedback),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (subject != null) 'subject': subject,
        'message': message,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to submit feedback');
  }
}