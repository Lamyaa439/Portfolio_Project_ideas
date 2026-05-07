import 'package:flutter/material.dart';

class ArtistStats extends StatelessWidget {
  final int artworksCount;

  const ArtistStats({super.key, required this.artworksCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFEDE8E0)),
          bottom: BorderSide(color: Color(0xFFEDE8E0)),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              '$artworksCount',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'عمل فني',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF6B6B6B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
