import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_model.dart';

class CartService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://accessories-eshop.runasp.net/api/cart"),
  );

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) throw Exception('No token found');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<CartModel> getCart() async {
    final headers = await _getHeaders();
    final response = await _dio.get('/', options: Options(headers: headers));
    return CartModel.fromJson(response.data);
  }

  Future<void> addItem(String productId, int quantity) async {
    final headers = await _getHeaders();
    await _dio.post(
      '/items',
      data: {
        "productId": productId,
        "quantity": quantity,
      },
      options: Options(headers: headers),
    );
  }

  Future<void> decrementItem(String itemId, int quantity) async {
    final headers = await _getHeaders();
    await _dio.post(
      '/items/decrement',
      data: {
        "itemId": itemId,
        "quantity": quantity,
      },
      options: Options(headers: headers),
    );
  }

  Future<void> deleteItem(String itemId) async {
    try {
      final headers = await _getHeaders();
      await _dio.delete(
        '/items/$itemId',
        data: {"id": itemId}, 
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      print(
          "----------------------------- Status code: ${e.response?.statusCode}");
      print("----------------------------- Response data: ${e.response?.data}");
    } catch (e) {
      print("----------------------------- Error: $e");
    }
  }

  Future<CartModel> applyCoupon(String couponCode) async {
    final headers = await _getHeaders();
    final response = await _dio.post(
      '/apply-coupon',
      data: {"couponCode": couponCode},
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      return CartModel.fromJson(response.data);
    } else {
      throw Exception(response.data['message'] ?? "Invalid coupon");
    }
  }
}
