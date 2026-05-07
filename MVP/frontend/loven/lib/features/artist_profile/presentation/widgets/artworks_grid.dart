import 'package:flutter/material.dart';

class ArtworksGrid extends StatelessWidget {
  const ArtworksGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder للأعمال — لاحقاً نربطها بـ API الأعمال
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(
        child: Text(
          'لا توجد أعمال بعد',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B6B6B),
          ),
        ),
      ),
    );
  }
}
