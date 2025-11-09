import '../../data/models/product_model.dart';

abstract class SearchState {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final List<ProductModels> products;
  SearchLoadedState(this.products);
}

class SearchErrorState extends SearchState {
  final String error;
  SearchErrorState(this.error);
}
