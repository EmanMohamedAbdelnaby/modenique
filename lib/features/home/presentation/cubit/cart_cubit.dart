import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cart_model.dart';
import '../../data/services/cart_service.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  CartService cartService = CartService();
  Future<void> loadCart() async {
    try {
      emit(CartLoading());
      final cart = await cartService.getCart();
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> addItem(String productId, int quantity) async {
    try {
      await cartService.addItem(productId, quantity);

      await loadCart();
    } catch (e) {
      emit(CartError("Failed to add item: $e"));
    }
  }

  Future<void> decrementItem(String itemId, int quantity) async {
    try {
      await cartService.decrementItem(itemId, quantity);
      await loadCart();
    } catch (e) {
      emit(CartError("Failed to decrement item: $e"));
    }
  }

  Future<void> deleteItem(String itemId) async {
    try {
      await cartService.deleteItem(itemId);
      await loadCart();
    } catch (e) {
      emit(CartError("Failed to delete item: $e"));
    }
  }

  Future<void> applyCoupon(String code) async {
    if (state is! CartLoaded) return;

    final currentCart = (state as CartLoaded).cart;

    try {
      final updatedCart = await cartService.applyCoupon(code);

      // استخدم المنتجات الحالية إذا السيرفر لم يرسل المنتجات
      final items = updatedCart.cartItems.isNotEmpty
          ? updatedCart.cartItems
          : currentCart.cartItems;

      final discount = updatedCart.couponDiscount;

      emit(CartLoaded(
        CartModel(
          cartId: updatedCart.cartId.isNotEmpty
              ? updatedCart.cartId
              : currentCart.cartId,
          cartItems: items,
          couponDiscount: discount,
        ),
        message: "Coupon applied successfully!",
      ));
    } catch (e) {
      print("Exception in applyCoupon: $e");

      emit(CartLoaded(
        currentCart,
        message: "Invalid coupon or request failed",
      ));
    }
  }
}
