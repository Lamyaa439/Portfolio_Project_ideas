import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/order_remote_datasource.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRemoteDataSource _remoteDataSource;

  OrderCubit(this._remoteDataSource) : super(OrderInitial());

  Future<void> createOrder({
    required String buyerId,
    required double subtotal,
    required double shippingFee,
    required double totalAmount,
    required List<Map<String, dynamic>> items,
  }) async {
    emit(OrderLoading());

    try {
      final order = await _remoteDataSource.createOrder(
        buyerId: buyerId,
        subtotal: subtotal,
        shippingFee: shippingFee,
        totalAmount: totalAmount,
        items: items,
      );

      emit(OrderLoaded(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> getMyOrders() async {
    emit(OrderLoading());

    try {
      final data = await _remoteDataSource.getMyOrders();

      emit(OrdersLoaded(data['orders'] ?? data['data'] ?? []));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> getBuyerOrders({
    required String buyerId,
  }) async {
    emit(OrderLoading());

    try {
      final data = await _remoteDataSource.getBuyerOrders(
        buyerId: buyerId,
      );

      emit(OrdersLoaded(data['orders'] ?? data['data'] ?? []));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> getArtistOrders({
    required String artistProfileId,
  }) async {
    emit(OrderLoading());

    try {
      final data = await _remoteDataSource.getArtistOrders(
        artistProfileId: artistProfileId,
      );

      emit(OrdersLoaded(data['orders'] ?? data['data'] ?? []));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    emit(OrderLoading());

    try {
      final order = await _remoteDataSource.updateOrderStatus(
        orderId: orderId,
        status: status,
      );

      emit(OrderLoaded(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
