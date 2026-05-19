import 'package:flutter/foundation.dart';

class ApiConstants {
  static const String baseUrl = kIsWeb
      ? 'http://localhost:5000/api/v1'
      : 'http://127.0.0.1:5000/api/v1';

  // =====================================================
  // Authentication
  // =====================================================

  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String refresh = '$baseUrl/auth/refresh';
  static const String logout = '$baseUrl/auth/logout';

  // =====================================================
  // Artist Profiles
  // =====================================================

  static const String createArtistProfile = '$baseUrl/artist-profiles';
  static const String myArtistProfile = '$baseUrl/artist-profiles/me';
  static const String artistProfiles = '$baseUrl/artist-profiles';
  static const String artistProfileByName = '$baseUrl/artist-profiles/by-name';

  // =====================================================
  // Cart
  // =====================================================

  static const String cart = '$baseUrl/carts';
  static const String cartItems = '$baseUrl/carts/items';

  // =====================================================
  // Orders
  // =====================================================

  static const String orders = '$baseUrl/orders/';
  static const String myOrders = '$baseUrl/orders/mine';

  // =====================================================
  // Artworks
  // =====================================================

  static const String artworks = '$baseUrl/artworks/';
  static const String artworkSearch = '$baseUrl/artworks/search';

  static const String myArtworks = '$baseUrl/artworks/mine';

  // =====================================================
  // Feedback
  // =====================================================

  static const String feedback = '$baseUrl/feedback/';

  // =====================================================
  // Reports
  // =====================================================

  static const String reports = '$baseUrl/reports/';
}
