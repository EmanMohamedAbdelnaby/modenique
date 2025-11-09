import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product_model.dart';
import '../../data/services/home_api_service.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final HomeApiServices homeApiServices;

  SearchCubit(this.homeApiServices) : super(SearchInitialState());

  List<ProductModels> allProducts = [];

  Future<void> getAllProducts() async {
    emit(SearchLoadingState());

    await homeApiServices.getItemsData().then((value) {
      allProducts = value;
      emit(SearchInitialState());
    }).onError((error, stackTrace) {
      emit(SearchErrorState(error.toString()));
    });
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      emit(SearchInitialState());
      return;
    }

    final results = allProducts.where((product) {
      final name = product.name?.toLowerCase() ?? '';
      final input = query.toLowerCase();
      return name.contains(input);
    }).toList();

    emit(SearchLoadedState(results));
  }
}
