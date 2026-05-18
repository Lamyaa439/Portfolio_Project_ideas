import 'artwork.dart';

/// **Artist Entity**
/// 
/// This is the core domain model representing an artist in the LOVEN marketplace.
/// 
/// **Architecture Role:**
/// - Part of the **Domain Layer**.
/// - Independent of any external libraries, UI, or API frameworks.
/// - Acts as a "Single Source of Truth" for artist data throughout the app.
/// 
/// **Key Features:**
/// - [isVerified]: Business logic flag to show the verification badge in UI.
/// - [artworks]: List of artwork entities associated with this artist profile.
/// - Null Safety: Fields like [bio] and [city] are nullable to handle incomplete profiles.

class Artist {
  /// Unique identifier for the artist profile (UUID).
  final String id;
  /// Links the artist profile to their primary User account.
  final String userId;
  final String displayName;
  final String? bio;
  final String? city;
  final String? profileImageUrl;
  final String? shippingPolicy;
  /// Flag indicating if the artist's identity has been verified.
  final bool isVerified;
  /// List of artworks belonging to this artist.
  final List<Artwork> artworks;

  const Artist({
    required this.id,
    required this.userId,
    required this.displayName,
    this.bio,
    this.city,
    this.profileImageUrl,
    this.shippingPolicy,
    this.isVerified = false,
    this.artworks = const [],
  });
}
