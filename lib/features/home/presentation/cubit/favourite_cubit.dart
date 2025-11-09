import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_model.dart';

class FavoriteCubit extends Cubit<List<ProductModels>> {
  FavoriteCubit() : super([]);

  void toggleFavorite(ProductModels product) {
    
    if (state.any((p) => p.id == product.id)) {
      emit(state.where((p) => p.id != product.id).toList());
    } else {
     
      emit([...state, product]);
    }
  }

  bool isFavorite(ProductModels product) {
    return state.any((p) => p.id == product.id);
  }
}
