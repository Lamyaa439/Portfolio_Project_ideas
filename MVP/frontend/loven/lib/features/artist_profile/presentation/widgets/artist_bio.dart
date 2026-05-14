import 'package:flutter/material.dart';

class ArtistBio extends StatelessWidget {
  final String? bio;

  const ArtistBio({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    if (bio == null || bio!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'نبذة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bio!,
            style: const TextStyle(
              fontSize: 14,
              height: 1.7,
              color: Color(0xFF6B6B6B),
            ),
          ),
        ],
      ),
    );
  }
}
