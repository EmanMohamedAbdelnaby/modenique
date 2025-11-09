import '../../data/models/notification_model.dart';
import '../../data/models/product_model.dart';

abstract class HomeState {}

class GetProductsIntialState extends HomeState {}

class GetProductsLodingState extends HomeState {}

class GetProductsSucessState extends HomeState {
  final List<ProductModels> products;
  GetProductsSucessState(this.products);
}

class GetProductsFailerState extends HomeState {
  final String errorMessage;
  GetProductsFailerState(this.errorMessage);
}

class NotificationLoadingState extends HomeState {}

class NotificationSuccessState extends HomeState {
  final List<NotificationModel> notifications;
  NotificationSuccessState(this.notifications);
}

class NotificationFailureState extends HomeState {
  final String errorMessage;
  NotificationFailureState(this.errorMessage);
}