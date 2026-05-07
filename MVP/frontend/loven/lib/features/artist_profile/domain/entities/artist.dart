class Artist {
  final String id;
  final String userId;
  final String displayName;
  final String? bio;
  final String? city;
  final String? profileImageUrl;
  final String? shippingPolicy;

  const Artist({
    required this.id,
    required this.userId,
    required this.displayName,
    this.bio,
    this.city,
    this.profileImageUrl,
    this.shippingPolicy,
  });
}
