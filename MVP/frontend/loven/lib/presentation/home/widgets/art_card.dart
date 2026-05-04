import 'package:flutter/material.dart';

// A StatelessWidget that takes an Artwork object (from classes.jpg diagram)
// and renders the painting, title, and price.

class ArtCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;

  const ArtCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
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
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white70,
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.red),
                    onPressed: () {}, // Logic to toggle favorite_artwork_ids
                  ),
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
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium, // Uses Almarai Bold
                ),
                const SizedBox(height: 4),
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
