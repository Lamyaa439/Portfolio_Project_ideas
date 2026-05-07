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
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDE8E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.local_shipping_outlined,
                  size: 18, color: Color(0xFF1A1A1A)),
              SizedBox(width: 8),
              Text(
                'سياسة الشحن',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
