import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/network/api_constants.dart';
import '../../core/storage/token_storage.dart';

class ArtistProfileRemoteDataSource {
  final TokenStorage _tokenStorage = TokenStorage();

  Future<Map<String, dynamic>> createProfile({
    required String displayName,
    String? city,
    String? bio,
    String? shippingPolicy,
    String? profileImageUrl,
  }) async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.post(
      Uri.parse(ApiConstants.createArtistProfile),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'display_name': displayName,
        if (city != null) 'city': city,
        if (bio != null) 'bio': bio,
        if (shippingPolicy != null) 'shipping_policy': shippingPolicy,
        if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to create artist profile');
  }

  Future<Map<String, dynamic>> getMyProfile() async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse(ApiConstants.myArtistProfile),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to load artist profile');
  }

  Future<Map<String, dynamic>> updateMyProfile({
    String? displayName,
    String? city,
    String? bio,
    String? shippingPolicy,
    String? profileImageUrl,
  }) async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.patch(
      Uri.parse(ApiConstants.myArtistProfile),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (displayName != null) 'display_name': displayName,
        if (city != null) 'city': city,
        if (bio != null) 'bio': bio,
        if (shippingPolicy != null) 'shipping_policy': shippingPolicy,
        if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to update artist profile');
  }

  Future<Map<String, dynamic>> deleteMyProfile() async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.delete(
      Uri.parse(ApiConstants.myArtistProfile),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to delete artist profile');
  }

  Future<Map<String, dynamic>> listProfiles({
    int limit = 20,
    int offset = 0,
  }) async {
    final uri = Uri.parse(ApiConstants.artistProfiles).replace(
      queryParameters: {
        'limit': limit.toString(),
        'offset': offset.toString(),
      },
    );

    final response = await http.get(uri);

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to load artist profiles');
  }

  Future<Map<String, dynamic>> getProfileByDisplayName({
    required String displayName,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.artistProfileByName}/$displayName'),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to load artist profile');
  }

  Future<Map<String, dynamic>> getProfileById({
    required String profileId,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.artistProfiles}/$profileId'),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to load artist profile');
  }

  Future<Map<String, dynamic>> listProfileArtworks({
    required String profileId,
    int limit = 20,
    int offset = 0,
    String status = 'available',
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.artistProfiles}/$profileId/artworks',
    ).replace(
      queryParameters: {
        'limit': limit.toString(),
        'offset': offset.toString(),
        'status': status,
      },
    );

    final response = await http.get(uri);

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to load artist artworks');
  }

  Future<Map<String, dynamic>> countProfileArtworks({
    required String profileId,
  }) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.artistProfiles}/$profileId/artworks/count',
      ),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to count artist artworks');
  }
}
