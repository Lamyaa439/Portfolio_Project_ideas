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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        bio!,
        style: const TextStyle(
          fontSize: 14,
          height: 1.7,
          color: Color(0xFF6B6B6B),
        ),
      ),
    );
  }
}
