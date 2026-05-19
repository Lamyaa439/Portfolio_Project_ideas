import 'package:flutter/foundation.dart';

class ApiConstants {
  static const String baseUrl = kIsWeb
      ? 'http://localhost:5000/api/v1'
      : 'http://127.0.0.1:5000/api/v1';

  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
}