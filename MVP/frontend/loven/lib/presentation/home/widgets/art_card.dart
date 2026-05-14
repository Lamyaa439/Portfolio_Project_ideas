import 'package:flutter/material.dart';
import 'package:loven/core/res/theme/app_colors.dart';
import 'package:loven/presentation/home/screens/art_details_screen.dart';

class ArtCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;
  final String artistName;
  final String description;
  final bool isGuest;
  final VoidCallback onActionPressed;

  const ArtCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.artistName,
    required this.description,
    required this.isGuest,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isGuest) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtDetailsScreen(
                artItem: {
                  'title': title,
                  'price': price,
                  'imageUrl': imageUrl,
                  'artistName': artistName,
                  'description': description,
                  'id': title,
                },
              ),
            ),
          );
        } else {
          // Redirects guest to signup/login instead of showing the SnackBar
          onActionPressed();
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: title,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: IconButton(
                          icon: const Icon(Icons.favorite_border,
                              color: Colors.red),
                          onPressed: onActionPressed,
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
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    "By $artistName",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$price SAR",
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
