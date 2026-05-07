import 'package:flutter/material.dart';
import '../../domain/entities/artist.dart';

class ArtistHeader extends StatelessWidget {
  final Artist artist;

  const ArtistHeader({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFC2410C),
            backgroundImage: artist.profileImageUrl != null
                ? NetworkImage(artist.profileImageUrl!)
                : null,
            child: artist.profileImageUrl == null
                ? Text(
                    artist.displayName.isNotEmpty ? artist.displayName[0] : '?',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            artist.displayName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),

          // City
          if (artist.city != null) ...[
            const SizedBox(height: 4),
            Text(
              artist.city!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B6B6B),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
