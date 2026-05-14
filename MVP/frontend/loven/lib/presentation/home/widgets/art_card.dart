import 'package:flutter/material.dart';
import 'package:loven/core/res/theme/app_colors.dart';
// A StatelessWidget that takes an Artwork object (from classes.jpg diagram)
// and renders the painting, title, and price.

class ArtCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;
  final String artistName;
  final VoidCallback onActionPressed;

  const ArtCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.artistName,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          280, // Fixed width so cards sit side-by-side for horizontal scrolling
      margin: const EdgeInsets.only(right: 16), // Space for the "swipe" effect
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface, // Uses your 0xFFF2F0EF off-white
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(imageUrl,
                    fit: BoxFit.cover, height: 200, width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50),
                  );
                }),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Column(
                  children: [
                    // Favorite Icon
                    CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border,
                            color: Colors.red),
                        onPressed: onActionPressed,
                        // Logic to toggle favorite_artwork_ids
                      ),
                    ),
                    const SizedBox(height: 8),
                    CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: IconButton(
                        icon: Icon(Icons.add_shopping_cart,
                            color: AppColors.primaryBlue),
                        onPressed: onActionPressed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  "By $artistName",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),

                // Price
                Text(
                  "$price SAR",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
