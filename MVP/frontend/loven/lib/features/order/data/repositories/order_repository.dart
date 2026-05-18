import 'package:loven/features/order/data/datasources/order_remote_datasource.dart';

class OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;

  OrderRepository(this._remoteDataSource);

  Future<Map<String, dynamic>> createOrder({
    required String buyerId,
    required double subtotal,
    required double shippingFee,
    required double totalAmount,
    required List<Map<String, dynamic>> items,
  }) async {
    return await _remoteDataSource.createOrder(
      buyerId: buyerId,
      subtotal: subtotal,
      shippingFee: shippingFee,
      totalAmount: totalAmount,
      items: items,
    );
  }

  Future<Map<String, dynamic>> getMyOrders() async {
    return await _remoteDataSource.getMyOrders();
  }

  Future<Map<String, dynamic>> getBuyerOrders({
    required String buyerId,
  }) async {
    return await _remoteDataSource.getBuyerOrders(
      buyerId: buyerId,
    );
  }

  Future<Map<String, dynamic>> getArtistOrders({
    required String artistProfileId,
  }) async {
    return await _remoteDataSource.getArtistOrders(
      artistProfileId: artistProfileId,
    );
  }

  Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    return await _remoteDataSource.updateOrderStatus(
      orderId: orderId,
      status: status,
    );
  }
}