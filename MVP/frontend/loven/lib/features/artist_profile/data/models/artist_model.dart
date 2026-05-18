import '../../domain/entities/artist.dart';
import '../../domain/entities/artwork.dart';

/// **Artist Model**
/// 
/// Data layer representation of the Artist. It extends the Domain Entity 
/// to add JSON serialization logic.
class ArtistModel extends Artist {
  const ArtistModel({
    required super.id,
    required super.userId,
    required super.displayName,
    super.bio,
    super.city,
    super.profileImageUrl,
    super.shippingPolicy,
    super.isVerified,
    super.artworks,
  });

  // object لما تجي بيانات من السيرفر نحولها إلى 
  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String,
      bio: json['bio'] as String?,
      city: json['city'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      shippingPolicy: json['shipping_policy'] as String?,
      isVerified: (json['is_verified'] as bool?) ?? false,

      artworks: (json['artworks'] as List<dynamic>?)
              ?.map((e) => Artwork(
                    id: e['id'] as String,
                    title: e['title'] as String,
                    price: (e['price'] as num).toDouble(),
                    imageUrl: e['image_url'] as String?,
                  ))
              .toList() ??
          const [],
    );
  }

  // JSON لما نرسل بيانات إلى السيرفر نحولها إلى 
  // Map like dict in python, String: keys and dynamic: Values
    Map<String, dynamic> toJson() {
      return {
        'name': displayName,
        'bio': bio,
        'city': city,
        'shipping_policy':shippingPolicy,
      };
    }
}
