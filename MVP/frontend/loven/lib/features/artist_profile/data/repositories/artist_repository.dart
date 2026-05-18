import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/network/api_constants.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/artist_model.dart';

/// Unified data access for the artist profile feature (MVVM — no separate DataSource).
///
/// ViewModel (Cubit) calls this class directly; it returns [ArtistModel] instances.
class ArtistRepository {
  final http.Client _client;
  final TokenStorage _tokenStorage;

  static const String _profilesPath = '/artist-profiles';
  static const String _artworksPath = '/artworks';

  ArtistRepository({
    http.Client? client,
    TokenStorage? tokenStorage,
  })  : _client = client ?? http.Client(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  // -------------------------------------------------------------------------
  // Public API
  // -------------------------------------------------------------------------

  /// **1) Public profile** — no JWT required.
  ///
  /// `GET /artist-profiles/{artistId}`
  Future<ArtistModel> getArtistById(String artistId) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$_profilesPath/$artistId');

    final response = await _client.get(
      uri,
      headers: const {'Content-Type': 'application/json'},
    );

    return _parseSuccessOrThrow(response, context: 'getArtistById');
  }

  /// **2) My profile** — requires a stored JWT.
  ///
  /// `GET /artist-profiles/me`
  Future<ArtistModel> getMyProfile() async {
    // Step 1: Read token from secure storage.
    final token = await _tokenStorage.getToken();

    // Step 2: Fail immediately if the user is not logged in.
    if (token == null || token.isEmpty) {
      throw Exception('Unauthorized: No token found. Please log in.');
    }

    // Step 3: Call the protected endpoint with Bearer auth.
    final uri = Uri.parse('${ApiConstants.baseUrl}$_profilesPath/me');

    final response = await _client.get(
      uri,
      headers: _authorizedHeaders(token),
    );

    return _parseSuccessOrThrow(response, context: 'getMyProfile');
  }

  /// **3) Update my profile** — PATCH only the fields that were passed in.
  ///
  /// `PATCH /artist-profiles/me`
  Future<ArtistModel> updateMyProfile({
    String? bio,
    String? city,
    String? shippingPolicy,
  }) async {
    // Step 1: Ensure we have a token (same guard as getMyProfile).
    final token = await _tokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Unauthorized: No token found. Please log in.');
    }

    // Step 2: Build the JSON body dynamically — omit null keys entirely.
    final Map<String, dynamic> payload = {};
    if (bio != null) payload['bio'] = bio;
    if (city != null) payload['city'] = city;
    if (shippingPolicy != null) {
      payload['shipping_policy'] = shippingPolicy;
    }

    if (payload.isEmpty) {
      throw Exception('No fields provided to update.');
    }

    // Step 3: Send PATCH with the JWT and encoded body.
    final uri = Uri.parse('${ApiConstants.baseUrl}$_profilesPath/me');

    final response = await _client.patch(
      uri,
      headers: _authorizedHeaders(token),
      body: jsonEncode(payload),
    );

    return _parseSuccessOrThrow(response, context: 'updateMyProfile');
  }

  /// **4) Update artwork** — PATCH only the fields passed in.
  ///
  /// `PATCH /artworks/{artworkId}`
  Future<ArtworkModel> updateArtwork(
    String artworkId, {
    String? title,
    String? description,
    double? price,
    int? quantityAvailable,
  }) async {
    // 1) Token validation: Ensure a JWT is present before sending protected requests.
    final token = await _tokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Unauthorized: No token found. Please log in.');
    }

    // 2) Build request: Add only non-null fields to the request body.
    final Map<String, dynamic> requestBody = {};
    if (title != null) requestBody['title'] = title;
    if (description != null) requestBody['description'] = description;
    if (price != null) requestBody['price'] = price;
    if (quantityAvailable != null) {
      requestBody['quantity_available'] = quantityAvailable;
    }

    if (requestBody.isEmpty) {
      throw Exception('No fields provided to update.');
    }

    // 3) Dispatch: Send PATCH request with Bearer authorization.
    final uri =
        Uri.parse('${ApiConstants.baseUrl}$_artworksPath/$artworkId');

    final response = await _client.patch(
      uri,
      headers: _authorizedHeaders(token),
      body: jsonEncode(requestBody),
    );

    // 4) Parse result: 200 indicates success; otherwise, throw a descriptive Exception.
    return _parseArtworkSuccessOrThrow(response, context: 'updateArtwork');
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  /// Standard headers for authenticated artist routes.
  Map<String, String> _authorizedHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// HTTP 200 → parse [ArtistModel]; anything else → descriptive [Exception].
  ArtistModel _parseSuccessOrThrow(
    http.Response response, {
    required String context,
  }) {
    if (response.statusCode == 200) {
      final Map<String, dynamic> body =
          json.decode(response.body) as Map<String, dynamic>;
      return ArtistModel.fromJson(body);
    }

    throw Exception(_errorMessage(response, context: context));
  }

  /// HTTP 200 → parse [ArtworkModel]; anything else → descriptive [Exception].
  ArtworkModel _parseArtworkSuccessOrThrow(
    http.Response response, {
    required String context,
  }) {
    if (response.statusCode == 200) {
      final Map<String, dynamic> body =
          json.decode(response.body) as Map<String, dynamic>;
      return ArtworkModel.fromJson(body);
    }

    throw Exception(_errorMessage(response, context: context));
  }

  /// Tries to read Flask's `{ "error": "..." }` message from the response body.
  String _errorMessage(http.Response response, {required String context}) {
    try {
      final Map<String, dynamic> body =
          json.decode(response.body) as Map<String, dynamic>;
      final serverMsg = body['error'] as String?;
      if (serverMsg != null && serverMsg.isNotEmpty) {
        return '$context failed (${response.statusCode}): $serverMsg';
      }
    } catch (_) {
      // Body was not JSON — fall through to generic message.
    }

    return '$context failed with HTTP ${response.statusCode}.';
  }
}
