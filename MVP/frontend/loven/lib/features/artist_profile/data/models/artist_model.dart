import '../../domain/entities/artist.dart';

class ArtistModel extends Artist {
  const ArtistModel({
    required super.id,
    required super.userId,
    required super.displayName,
    super.bio,
    super.city,
    super.profileImageUrl,
    super.shippingPolicy,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String,
      bio: json['bio'] as String?,
      city: json['city'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      shippingPolicy: json['shipping_policy'] as String?,
    );
  }
}
