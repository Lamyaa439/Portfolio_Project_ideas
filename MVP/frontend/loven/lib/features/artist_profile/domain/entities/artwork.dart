class Artwork {
  final String id;
  final String title;
  final double price;
  final String? imageUrl;

  const Artwork({
    required this.id,
    required this.title,
    required this.price,
    this.imageUrl,
  });
}
