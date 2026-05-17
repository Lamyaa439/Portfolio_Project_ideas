import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/network/api_constants.dart';
import '../../core/storage/token_storage.dart';

class AuthRemoteDataSource {
  final TokenStorage _tokenStorage = TokenStorage();

  // =========================
  // Register
  // =========================
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String systemRole,
    String? fcmToken,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.register),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'system_role': systemRole,
        'fcm_token': fcmToken,
      }),
    );

    print("REGISTER STATUS: ${response.statusCode}");
    print("REGISTER BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      await _tokenStorage.saveAccessToken(
        data['access_token'],
      );

      return data;
    }

    throw Exception(
      data['error'] ?? 'Registration failed',
    );
  }

  // =========================
  // Login
  // =========================
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'fcm_token': fcmToken,
      }),
    );

    print("LOGIN STATUS: ${response.statusCode}");
    print("LOGIN BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await _tokenStorage.saveAccessToken(
        data['access_token'],
      );

      return data;
    }

    throw Exception(
      data['error'] ?? 'Login failed',
    );
  }

  // =========================
  // Logout
  // =========================
  Future<void> logout() async {
    await http.post(
      Uri.parse(ApiConstants.logout),
    );

    await _tokenStorage.clearAccessToken();
  }
}
