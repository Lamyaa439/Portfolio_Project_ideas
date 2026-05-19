import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/network/api_constants.dart';
import '../../../core/storage/token_storage.dart';
import 'artist_model.dart';

/// Single gateway to Flask for artist profiles and artworks (MVC — no interface).
///
/// ViewModels call this class directly. It owns HTTP, JWT headers, and parsing.
class ArtistRepository {
  final http.Client _client;
  final TokenStorage _tokenStorage;

  /// Matches blueprint `url_prefix="/artist-profiles"` registered at `/api/v1`.
  static const String _profilesPath = '/artist-profiles';

  /// Matches blueprint registered at `/api/v1/artworks`.
  static const String _artworksPath = '/artworks';

  ArtistRepository({
    http.Client? client,
    TokenStorage? tokenStorage,
  })  : _client = client ?? http.Client(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  // ===========================================================================
  // Artist profile — GET / PATCH
  // ===========================================================================

  /// Public storefront profile. No JWT (`GET /artist-profiles/<profile_id>`).
  Future<ArtistModel> getArtistById(String profileId) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$_profilesPath/$profileId');

    final response = await _client.get(
      uri,
      headers: const {'Content-Type': 'application/json'},
    );

    return _parseArtistOrThrow(response, context: 'getArtistById');
  }

  /// Logged-in artist's own profile (`GET /artist-profiles/me`, `@jwt_required`).
  Future<ArtistModel> getMyProfile() async {
    final token = await _requireToken();

    final uri = Uri.parse('${ApiConstants.baseUrl}$_profilesPath/me');

    final response = await _client.get(
      uri,
      headers: _authHeaders(token),
    );

    return _parseArtistOrThrow(response, context: 'getMyProfile');
  }

  /// Partial profile update (`PATCH /artist-profiles/me`).
  ///
  /// Only passes non-null arguments — mirrors Flask `_ARTIST_WRITABLE_FIELDS`.
  Future<ArtistModel> updateMyProfile({
    String? displayName,
    String? bio,
    String? city,
    String? shippingPolicy,
    String? profileImageUrl,
  }) async {
    final token = await _requireToken();

    // Dynamic body: Flask returns 400 if the payload is empty.
    final Map<String, dynamic> body = {};
    if (displayName != null) body['display_name'] = displayName;
    if (bio != null) body['bio'] = bio;
    if (city != null) body['city'] = city;
    if (shippingPolicy != null) body['shipping_policy'] = shippingPolicy;
    if (profileImageUrl != null) body['profile_image_url'] = profileImageUrl;

    if (body.isEmpty) {
      throw Exception('updateMyProfile: no fields provided.');
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}$_profilesPath/me');

    final response = await _client.patch(
      uri,
      headers: _authHeaders(token),
      body: jsonEncode(body),
    );

    return _parseArtistOrThrow(response, context: 'updateMyProfile');
  }

  // ===========================================================================
  // Artworks — GET lists / GET one / PATCH
  // ===========================================================================

  /// Public catalog on an artist page (`GET /artist-profiles/<id>/artworks`).
  Future<List<ArtworkModel>> listArtworksForProfile(
    String profileId, {
    int limit = 20,
    int offset = 0,
    String? status,
  }) async {
    final query = <String, String>{
      'limit': '$limit',
      'offset': '$offset',
      if (status != null) 'status': status,
    };

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}$_profilesPath/$profileId/artworks',
    ).replace(queryParameters: query);

    final response = await _client.get(
      uri,
      headers: const {'Content-Type': 'application/json'},
    );

    return _parseArtworkListOrThrow(response, context: 'listArtworksForProfile');
  }

  /// Artist dashboard — all own listings (`GET /artworks/mine`, JWT required).
  Future<List<ArtworkModel>> listMyArtworks({
    int limit = 20,
    int offset = 0,
  }) async {
    final token = await _requireToken();

    final uri = Uri.parse('${ApiConstants.baseUrl}$_artworksPath/mine').replace(
      queryParameters: {
        'limit': '$limit',
        'offset': '$offset',
      },
    );

    final response = await _client.get(
      uri,
      headers: _authHeaders(token),
    );

    return _parseArtworkListOrThrow(response, context: 'listMyArtworks');
  }

  /// Single artwork detail (`GET /artworks/<artwork_id>`, public).
  Future<ArtworkModel> getArtworkById(String artworkId) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$_artworksPath/$artworkId');

    final response = await _client.get(
      uri,
      headers: const {'Content-Type': 'application/json'},
    );

    return _parseArtworkOrThrow(response, context: 'getArtworkById');
  }

  /// Partial artwork update (`PATCH /artworks/<artwork_id>`, JWT + ownership).
  Future<ArtworkModel> updateArtwork(
    String artworkId, {
    String? title,
    String? description,
    double? price,
    int? quantityAvailable,
    double? shippingFee,
    String? artworkImageUrl,
    String? status,
  }) async {
    final token = await _requireToken();

    final Map<String, dynamic> body = {};
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (price != null) body['price'] = price;
    if (quantityAvailable != null) {
      body['quantity_available'] = quantityAvailable;
    }
    if (shippingFee != null) body['shipping_fee'] = shippingFee;
    if (artworkImageUrl != null) body['artwork_image_url'] = artworkImageUrl;
    if (status != null) body['status'] = status;

    if (body.isEmpty) {
      throw Exception('updateArtwork: no fields provided.');
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}$_artworksPath/$artworkId');

    final response = await _client.patch(
      uri,
      headers: _authHeaders(token),
      body: jsonEncode(body),
    );

    return _parseArtworkOrThrow(response, context: 'updateArtwork');
  }

  // ===========================================================================
  // Auth & HTTP helpers
  // ===========================================================================

  /// Step 1 of every protected route: read JWT from secure storage.
  /// Step 2: fail fast — Flask would return 401 anyway, but this gives a clear app error.
  Future<String> _requireToken() async {
    final token = await _tokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Unauthorized: No token found. Please log in.');
    }
    return token;
  }

  /// Bearer header required by `@jwt_required()` routes.
  Map<String, String> _authHeaders(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  ArtistModel _parseArtistOrThrow(
    http.Response response, {
    required String context,
  }) {
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      return ArtistModel.fromJson(body);
    }
    throw Exception(_extractError(response, context));
  }

  ArtworkModel _parseArtworkOrThrow(
    http.Response response, {
    required String context,
  }) {
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      return ArtworkModel.fromJson(body);
    }
    throw Exception(_extractError(response, context));
  }

  List<ArtworkModel> _parseArtworkListOrThrow(
    http.Response response, {
    required String context,
  }) {
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      return ArtistModel.parseArtworkList(body);
    }
    throw Exception(_extractError(response, context));
  }

  /// Flask errors are consistently shaped as `{ "error": "message" }`.
  String _extractError(http.Response response, String context) {
    try {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final msg = body['error'] as String?;
      if (msg != null && msg.isNotEmpty) {
        return '$context failed (${response.statusCode}): $msg';
      }
    } catch (_) {
      // Non-JSON body (e.g. HTML 502 page).
    }
    return '$context failed with HTTP ${response.statusCode}.';
  }
}
