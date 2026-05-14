import 'package:flutter/material.dart';

class ArtistShippingPolicy extends StatelessWidget {
  final String? shippingPolicy;

  const ArtistShippingPolicy({super.key, required this.shippingPolicy});

  @override
  Widget build(BuildContext context) {
    if (shippingPolicy == null || shippingPolicy!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.local_shipping_outlined,
                size: 18,
                color: Color(0xFF1A1A1A),
              ),
              SizedBox(width: 8),
              Text(
                'سياسة الشحن',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            shippingPolicy!,
            style: const TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Color(0xFF6B6B6B),
            ),
          ),
        ],
      ),
    );
  }
}
