import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/network/api_constants.dart';
import '../../core/storage/token_storage.dart';

class CartRemoteDataSource {
  final TokenStorage _tokenStorage = TokenStorage();

  Future<Map<String, dynamic>> getCart({
    bool includeArtwork = true,
  }) async {
    final token = await _tokenStorage.getAccessToken();

    final uri = Uri.parse(ApiConstants.cart).replace(
      queryParameters: {
        'include_artwork': includeArtwork.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to load cart');
  }

  Future<Map<String, dynamic>> addCartItem({
    required String artworkId,
    int quantity = 1,
  }) async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.post(
      Uri.parse(ApiConstants.cartItems),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'artwork_id': artworkId,
        'quantity': quantity,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to add item to cart');
  }

  Future<Map<String, dynamic>> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.patch(
      Uri.parse('${ApiConstants.cartItems}/$itemId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'quantity': quantity,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to update cart item');
  }

  Future<Map<String, dynamic>> removeCartItem({
    required String itemId,
  }) async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.delete(
      Uri.parse('${ApiConstants.cartItems}/$itemId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to remove cart item');
  }

  Future<Map<String, dynamic>> clearCart() async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.delete(
      Uri.parse(ApiConstants.cart),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to clear cart');
  }
}
