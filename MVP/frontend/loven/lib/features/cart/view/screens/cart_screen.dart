import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/cubit/cart_cubit.dart';
import '../../controller/cubit/cart_state.dart';
import '../../data/models/cart_model.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getCart();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CartError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is CartLoaded) {
          final cart = CartModel.fromJson(state.cart);

          if (cart.items.isEmpty) {
            return const Center(
              child: Text('Your cart is empty'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      return CartItemWidget(
                        item: item,
                        onIncrease: () {
                          context.read<CartCubit>().updateItem(
                                itemId: item.id,
                                quantity: item.quantity + 1,
                              );
                        },
                        onDecrease: () {
                          context.read<CartCubit>().updateItem(
                                itemId: item.id,
                                quantity: item.quantity - 1,
                              );
                        },
                        onRemove: () {
                          context.read<CartCubit>().removeItem(
                                itemId: item.id,
                              );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _CartSummary(cart: cart),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _CartSummary extends StatelessWidget {
  final CartModel cart;

  const _CartSummary({
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SummaryRow(
          label: 'Subtotal',
          value: '${cart.subtotal.toStringAsFixed(2)} SAR',
        ),
        _SummaryRow(
          label: 'Shipping',
          value: '${cart.shippingFee.toStringAsFixed(2)} SAR',
        ),
        const Divider(),
        _SummaryRow(
          label: 'Total',
          value: '${cart.totalAmount.toStringAsFixed(2)} SAR',
          isBold: true,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Navigate to checkout/order creation screen.
            },
            child: const Text('Checkout'),
          ),
        ),
        TextButton(
          onPressed: () {
            context.read<CartCubit>().clearCart();
          },
          child: const Text('Clear Cart'),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = isBold
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}