import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/cart_remote_datasource.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRemoteDataSource _remoteDataSource;

  CartCubit(this._remoteDataSource) : super(CartInitial());

  Future<void> getCart() async {
    emit(CartLoading());

    try {
      final cart = await _remoteDataSource.getCart();

      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> addItem({
    required String artworkId,
    int quantity = 1,
  }) async {
    try {
      await _remoteDataSource.addCartItem(
        artworkId: artworkId,
        quantity: quantity,
      );

      await getCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> updateItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      await _remoteDataSource.updateCartItem(
        itemId: itemId,
        quantity: quantity,
      );

      await getCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> removeItem({
    required String itemId,
  }) async {
    try {
      await _remoteDataSource.removeCartItem(
        itemId: itemId,
      );

      await getCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> clearCart() async {
    try {
      await _remoteDataSource.clearCart();

      await getCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
