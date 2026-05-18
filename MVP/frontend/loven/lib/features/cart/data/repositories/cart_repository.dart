import 'package:loven/features/cart/data/datasources/cart_remote_datasource.dart';

class CartRepository {
  final CartRemoteDataSource _remoteDataSource;

  CartRepository(this._remoteDataSource);

  Future<Map<String, dynamic>> getCart() async {
    return await _remoteDataSource.getCart();
  }

  Future<Map<String, dynamic>> addToCart({
    required String artworkId,
    required int quantity,
  }) async {
    return await _remoteDataSource.addToCart(
      artworkId: artworkId,
      quantity: quantity,
    );
  }

  Future<Map<String, dynamic>> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    return await _remoteDataSource.updateCartItem(
      itemId: itemId,
      quantity: quantity,
    );
  }

  Future<Map<String, dynamic>> removeCartItem({
    required String itemId,
  }) async {
    return await _remoteDataSource.removeCartItem(
      itemId: itemId,
    );
  }

  Future<Map<String, dynamic>> clearCart() async {
    return await _remoteDataSource.clearCart();
  }
}