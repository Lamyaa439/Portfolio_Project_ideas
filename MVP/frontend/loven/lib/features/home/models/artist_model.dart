import '../../artist_profile/domain/entities/artist.dart';
import '../../artist_profile/domain/entities/artwork.dart';

class ArtistModel extends Artist {
  const ArtistModel({
    required super.id,
    required super.userId,
    required super.displayName,
    super.bio,
    super.city,
    super.profileImageUrl,
    super.shippingPolicy,
    super.artworks,
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
}
