import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:loven/core/network/api_constants.dart';
import 'package:loven/core/storage/token_storage.dart';

class ArtworkRepository {
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<dynamic>> getArtworks() async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse(ApiConstants.artworks),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data is List) return data;
      if (data['artworks'] is List) return data['artworks'];
      return [];
    }

    throw Exception(data['error'] ?? 'Failed to load artworks');
  }

  Future<Map<String, dynamic>> getArtworkById(String artworkId) async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse('${ApiConstants.artworks}/$artworkId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to load artwork');
  }
}