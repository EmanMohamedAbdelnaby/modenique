import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../data/models/coupon_model.dart';
import 'coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  CouponCubit() : super(CouponInitial());

  final Dio _dio = Dio();

  Future<void> getCoupons() async {
    emit(CouponLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("accessToken");

      if (token == null) {
        emit(CouponError("Token not found"));
        return;
      }

      final response = await _dio.get(
        'https://accessories-eshop.runasp.net/api/coupons',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('coupons')) {
          final List<dynamic> couponsJson = responseData['coupons'];

          final coupons = couponsJson
              .map((json) => CouponModel.fromJson(json as Map<String, dynamic>))
              .toList();

          emit(CouponLoaded(coupons));
        } else {
          emit(CouponError("Unexpected data format"));
        }
      } else {
        emit(CouponError("Failed to load coupons"));
      }
    } catch (e) {
      emit(CouponError("Error: ${e.toString()}"));
    }
  }
}
