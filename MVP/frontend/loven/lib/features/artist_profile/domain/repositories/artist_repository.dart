import '../entities/artist.dart';

/// **Artist Repository Interface**
/// 
/// This abstract class defines the "contract" for all artist-related data operations.
/// It acts as a bridge between the Domain layer and the Data layer.

abstract class ArtistRepository {
  /// Fetches the profile of the currently authenticated artist.
  /// Used for the **Artist Dashboard**.
  /// Corresponds to: `GET /artist-profiles/me`
  Future<Artist> getMyProfile();

  /// Fetches any artist's profile by their unique [artistId].
  /// Used for the public **Artist Profile Screen**.
  /// Corresponds to: `GET /artists/{id}`
  Future<Artist> getArtistById(String artistId);

  /// Updates the current artist's bio, city, or shipping policy.
  /// Corresponds to: `PATCH /artists/me`
  Future<Artist> updateMyProfile({
    String? bio,
    String? city,
    String? shippingPolicy,
  });

}
