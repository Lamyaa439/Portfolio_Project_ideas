import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:loven/core/network/api_constants.dart';
import 'package:loven/core/storage/token_storage.dart';

class ArtistProfileRemoteDataSource {
  final TokenStorage _tokenStorage = TokenStorage();

  Future<Map<String, dynamic>> createProfile({
    required String displayName,
    required String bio,
    required String city,
    String? profileImageUrl,
    String? shippingPolicy,
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
        'bio': bio,
        'city': city,
        'profile_image_url': profileImageUrl,
        'shipping_policy': shippingPolicy,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getMyProfile() async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse(ApiConstants.myArtistProfile),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateMyProfile({
    String? displayName,
    String? bio,
    String? city,
    String? profileImageUrl,
    String? shippingPolicy,
  }) async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.patch(
      Uri.parse(ApiConstants.myArtistProfile),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'display_name': displayName,
        'bio': bio,
        'city': city,
        'profile_image_url': profileImageUrl,
        'shipping_policy': shippingPolicy,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> deleteMyProfile() async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.delete(
      Uri.parse(ApiConstants.myArtistProfile),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> listProfiles({
    int limit = 20,
    int offset = 0,
  }) async {
    final uri = Uri.parse(
      ApiConstants.artistProfiles,
    ).replace(
      queryParameters: {
        'limit': '$limit',
        'offset': '$offset',
      },
    );

    final response = await http.get(uri);

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getProfileById({
    required String profileId,
  }) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.artistProfiles}/$profileId',
      ),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getProfileByDisplayName({
    required String displayName,
  }) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.artistProfileByName}/$displayName',
      ),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> listProfileArtworks({
    required String profileId,
  }) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.artistProfiles}/$profileId/artworks',
      ),
    );

    return jsonDecode(response.body);
  }
}