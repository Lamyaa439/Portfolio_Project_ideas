import 'package:flutter/material.dart';
import 'package:loven/core/res/theme/app_colors.dart';

class ArtDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> artItem;

  const ArtDetailsScreen({super.key, required this.artItem});

  @override
  Widget build(BuildContext context) {
    // 1. Define theme variables
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      // Use theme background color instead of hardcoded white
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Icon color adapts to theme
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        title: Text(
          "Details",
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artwork Card
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? Colors.black54 : Colors.black12,
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Stack(
                    children: [
                      Hero(
                        tag: artItem['id'] ?? 'art_image',
                        child: Image.asset(
                          artItem['imageUrl'] ?? '',
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Floating Icons
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Column(
                          children: [
                            _buildFloatingIcon(
                                Icons.shopping_cart_outlined, isDarkMode, () {
                              print("Added to cart");
                            }),
                            const SizedBox(height: 12),
                            _buildFloatingIcon(
                                Icons.favorite_border, isDarkMode, () {
                              print("Liked!");
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        artItem['title'] ?? 'Untitled',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface, // Adapts color
                        ),
                      ),
                      Text(
                        '${artItem['price']} SAR',
                        style: const TextStyle(
                            fontSize: 20,
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.deepPurple,
                        child:
                            Icon(Icons.person, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        artItem['artistName'] ?? 'Unknown Artist',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface
                              .withOpacity(0.7), // Subtle adapt
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 40, color: theme.dividerColor),
                  Text(
                    'About this piece',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    artItem['description'] ?? 'No description provided.',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'More like this',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isDarkMode
                                ? Colors.grey[900]
                                : Colors.grey[100],
                            image: const DecorationImage(
                              image: AssetImage('images/art2.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated helper to handle dark mode icon backgrounds
  Widget _buildFloatingIcon(
      IconData icon, bool isDarkMode, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // In dark mode, we use a darker, slightly transparent circle
          color: isDarkMode
              ? Colors.black.withOpacity(0.7)
              : Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isDarkMode ? Colors.white : Colors.black,
          size: 22,
        ),
      ),
    );
  }
}
