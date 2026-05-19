import 'package:loven/features/cart/data/models/cart_item_model.dart';

class CartModel {
  final String? id;
  final List<CartItemModel> items;
  final double subtotal;
  final double shippingFee;
  final double totalAmount;

  CartModel({
    this.id,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.totalAmount,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final data = json['cart'] ?? json;

    return CartModel(
      id: data['id']?.toString(),
      items: (data['items'] as List? ?? [])
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      subtotal: _toDouble(data['subtotal']),
      shippingFee: _toDouble(data['shipping_fee']),
      totalAmount: _toDouble(data['total_amount']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0;
  }
}