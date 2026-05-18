import 'package:flutter/material.dart';
import '../../data/models/artist_model.dart';

class ArtistHeader extends StatelessWidget {
  final ArtistModel artist;

  const ArtistHeader({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        children: [
          // صورة دائرية
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFB8A8E8),
                  Color(0xFF8B7AB8),
                ],
              ),
            ),
            child: artist.profileImageUrl != null
                ? ClipOval(
                    child: Image.network(
                      artist.profileImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Text(
                      artist.name.isNotEmpty
                          ? artist.name[0]
                          : '?',
                      style: const TextStyle(
                        fontSize: 42,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 16),

          // اسم الفنان
          Text(
            artist.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),

          // المدينة
          if (artist.city != null) ...[
            const SizedBox(height: 4),
            Text(
              artist.city!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8E8E93),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
