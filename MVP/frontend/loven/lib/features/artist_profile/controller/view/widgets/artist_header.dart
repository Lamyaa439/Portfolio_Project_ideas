import 'package:flutter/material.dart';
import '../../../domain/entities/artist.dart';

class ArtistHeader extends StatelessWidget {
  final Artist artist;

  const ArtistHeader({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    final artworksCount = artist.artworks.length;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 36, bottom: 28),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFEDE7F6),
                Color(0xFFD8C6F0),
                Color(0xFFF8F5FC),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: artist.profileImageUrl != null &&
                          artist.profileImageUrl!.isNotEmpty
                      ? Image.network(
                          artist.profileImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _AvatarLetter(name: artist.displayName),
                        )
                      : _AvatarLetter(name: artist.displayName),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                artist.displayName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              if (artist.city != null && artist.city!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 17,
                      color: Color(0xFF7E6AA8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      artist.city!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B6FC1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.palette_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$artworksCount الأعمال',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvatarLetter extends StatelessWidget {
  final String name;

  const _AvatarLetter({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF9F84C7),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            fontSize: 42,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
