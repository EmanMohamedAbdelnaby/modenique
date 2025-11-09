import '../../data/models/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartModel cart;
  final String? message;
  CartLoaded(this.cart, {this.message});
}


class CartError extends CartState {
  final String message;
  CartError(this.message);
}


class CartMessage extends CartState {
  final String message;
  CartMessage(this.message);
}
