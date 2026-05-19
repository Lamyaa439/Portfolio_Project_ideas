import '../../artist_profile/domain/entities/artist.dart';
import '../../artist_profile/domain/entities/artwork.dart';

// ---------------------------------------------------------------------------
// ArtworkModel
// ---------------------------------------------------------------------------

/// Single artwork row as returned by the LOVEN API (`_artwork_to_dict`).
class ArtworkModel {
  final String id;
  final String artistProfileId;
  final String title;
  final String? description;

  /// Price comes from Flask as a string (Decimal precision).
  final double? price;

  final int? quantityAvailable;
  final double? shippingFee;
  final String? artworkImageUrl;
  final String? status;

  const ArtworkModel({
    required this.id,
    required this.artistProfileId,
    required this.title,
    this.description,
    this.price,
    this.quantityAvailable,
    this.shippingFee,
    this.artworkImageUrl,
    this.status,
  });

  factory ArtworkModel.fromJson(Map<String, dynamic> json) {
    // PATCH /artworks/:id returns `{ "artwork": { ... } }` — unwrap when present.
    final Map<String, dynamic> data = json['artwork'] is Map<String, dynamic>
        ? json['artwork'] as Map<String, dynamic>
        : json;

    return ArtworkModel(
      id: data['id']?.toString() ?? '',
      artistProfileId: data['artist_profile_id']?.toString() ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String?,
      price: _parseDouble(data['price']),
      quantityAvailable: data['quantity_available'] as int?,
      shippingFee: _parseDouble(data['shipping_fee']),
      artworkImageUrl: data['artwork_image_url'] as String?,
      status: data['status'] as String?,
    );
  }

  /// Builds the JSON body for `PATCH /artworks/:id`.
  ///
  /// Collection-if ensures only non-null fields are sent so the backend updates
  /// exactly what changed (partial update / no mass-assignment noise).
  Map<String, dynamic> toJson() {
    return {
      if (title.isNotEmpty) 'title': title,
      if (description != null) 'description': description,
      if (price != null) 'price': price,
      if (quantityAvailable != null) 'quantity_available': quantityAvailable,
      if (shippingFee != null) 'shipping_fee': shippingFee,
      if (artworkImageUrl != null) 'artwork_image_url': artworkImageUrl,
      if (status != null) 'status': status,
    };
  }

  /// Backend may send numbers as strings — parse safely.
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String && value.isNotEmpty) {
      return double.tryParse(value);
    }
    return null;
  }
}

// ---------------------------------------------------------------------------
// ArtistModel
// ---------------------------------------------------------------------------

/// Artist profile as returned by `GET/PATCH /artist-profiles/...`.
class ArtistModel {
  final String id;
  final String userId;

  /// Maps from backend `display_name` (single name field — no first/last).
  final String name;

  final String? bio;
  final String? city;
  final String? profileImageUrl;
  final String? shippingPolicy;
  final bool isVerified;

  /// Optional nested list when the API embeds artworks on the profile payload.
  final List<ArtworkModel> artworks;

  const ArtistModel({
    required this.id,
    required this.userId,
    required this.name,
    this.bio,
    this.city,
    this.profileImageUrl,
    this.shippingPolicy,
    this.isVerified = false,
    this.artworks = const [],
  });

  /// Parses either:
  /// - `{ "profile": { ... } }` (GET /me, GET /:id, PATCH /me)
  /// - or a flat profile map.
  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['profile'] is Map<String, dynamic>
        ? json['profile'] as Map<String, dynamic>
        : json;

    return ArtistModel(
      id: data['id']?.toString() ?? '',
      userId: data['user_id']?.toString() ?? '',
      name: data['display_name'] as String? ?? '',
      bio: data['bio'] as String?,
      city: data['city'] as String?,
      profileImageUrl: data['profile_image_url'] as String?,
      shippingPolicy: data['shipping_policy'] as String?,
      isVerified: data['is_verified'] as bool? ?? false,
      artworks: _parseArtworks(data['artworks']),
    );
  }

  static List<ArtworkModel> _parseArtworks(dynamic raw) {
    if (raw is! List) return const [];

    return raw
        .whereType<Map<String, dynamic>>()
        .map(ArtworkModel.fromJson)
        .toList();
  }

  /// Only fields the artist is allowed to update on `PATCH /artist-profiles/me`.
  ///
  /// `name` is sent as `display_name` because that is what Flask expects.
  Map<String, dynamic> toJson() {
    return {
      'display_name': name,
      if (bio != null) 'bio': bio,
      if (city != null) 'city': city,
      if (shippingPolicy != null) 'shipping_policy': shippingPolicy,
    };
  }
}
