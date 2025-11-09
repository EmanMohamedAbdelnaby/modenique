import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/notification_model.dart';
import '../../data/services/home_api_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(GetProductsIntialState());
  final HomeApiServices apiServices = HomeApiServices();

  Future<void> getAllItems() async {
    emit(GetProductsLodingState());
    try {
      final products = await apiServices.getItemsData();
      emit(GetProductsSucessState(products));
    } catch (e) {
      emit(GetProductsFailerState(e.toString()));
    }
  }

  Future<void> getNotifications() async {
    emit(NotificationLoadingState());
    try {
      List<NotificationModel> notifications = await apiServices.getNotifications();
      emit(NotificationSuccessState(notifications));
    } catch (e) {
      emit(NotificationFailureState(e.toString()));
    }
  }
}
