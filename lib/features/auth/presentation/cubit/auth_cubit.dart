import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti_final_project_new/features/auth/data/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  ApiServices apiServices = ApiServices();

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    try {
      final response = await apiServices.checkeAcount(email, password);

      if (response == null) {
        emit(AuthFailure("No response from server"));
        return;
      }

      final statusCode = response.statusCode ?? 0;
      final data = response.data;

      if (statusCode == 200 && data != null) {
        final accessToken = data["accessToken"];
        final refreshToken = data["refreshToken"];
        final expiresAt = data["expiresAtUtc"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("accessToken", accessToken);
        await prefs.setString("refreshToken", refreshToken);
        await prefs.setString("expiresAtUtc", expiresAt);

        emit(AuthSuccess("Login successful"));
      } else if (statusCode == 400) {
        String errorMessage = "Invalid email or password";
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
        emit(AuthFailure(errorMessage));
      } else {
        emit(AuthFailure("Login failed with status: $statusCode"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void logout() async {
    emit(AuthLoading());

    try {
      final response = await apiServices.logout();

      if (response != null && response.statusCode == 200) {
        print("_______________________${response.data}");
        emit(AuthLoggedOut("Logout successful"));

        // 🧹 بعد اللوج آوت نحذف التوكن من التخزين
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("accessToken");
      } else {
        emit(
          AuthFailure("Logout failed: ${response?.data ?? 'Unknown error'}"),
        );
      }
    } catch (error) {
      print("--------------------------------$error");
      emit(AuthFailure("Logout failed: ${error.toString()}"));
    }
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
  }) async {
    emit(AuthLoading());

    try {
      final response = await apiServices.createNewAcount(
        email,
        password,
        firstname,
        lastname,
      );

      if (response != null && response.statusCode == 200) {
        emit(AuthSuccess("Account created successfully!"));
      } else if (response != null && response.statusCode == 400) {
        final message = response.data['message'] ?? "Invalid data provided";
        emit(AuthFailure("Registration failed: $message"));
      } else {
        emit(
          AuthFailure(
            "Registration failed with status: ${response?.statusCode ?? "Invalid data provided"}",
          ),
        );
      }
    } catch (e) {
      emit(AuthFailure("Registration failed: $e"));
    }
  }

  Future<void> sendOTP(String email, String otp) async {
    emit(AuthLoading());

    await apiServices
        .sendOTP(email, otp)
        .then(
          (response) {
            print("_______________________${response.data}");
            emit(AuthSuccess("OTP Verified Successfully"));
          },
          onError: (error) {
            print("--------------------------------$error");
            emit(AuthFailure("OTP verification failed: ${error.toString()}"));
          },
        );
  }

  Future<void> resendOTP(String email) async {
    emit(AuthLoading());
    apiServices
        .resendOTP(email)
        .then(
          (value) {
            print("OTP Resent: ${value.data}");
            emit(OTPResendSuccess("OTP resent successfully to $email"));
          },
          onError: (e) {
            print(" Error resending OTP: $e");
            emit(AuthFailure("Failed to resend OTP: $e"));
          },
        );
  }

  Future<void> forgetPassword(String email) async {
    emit(AuthLoading());
    await apiServices
        .forgetPssword(email)
        .then(
          (response) {
            print("_________________________${response!.data}");
            emit(AuthSuccess("Password reset link sent to your email"));
          },
          onError: (error) {
            print("--------------------------------$error");
            emit(AuthFailure("Failed to send reset link: ${error.toString()}"));
          },
        );
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(AuthLoading());
    await apiServices
        .resetPassword(email: email, otp: otp, newPassword: newPassword)
        .then(
          (value) {
            emit(AuthSuccess("Password reset successfully"));
          },
          onError: (e) {
            emit(AuthFailure("Failed to reset password: $e"));
          },
        );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    emit(AuthLoading());

    try {
      final response = await apiServices.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );

      if (response != null && response.statusCode == 200) {
        emit(AuthSuccess("Password changed successfully"));
      } else {
        emit(AuthFailure("Failed to change password: ${response?.data}"));
      }
    } catch (e) {
      emit(AuthFailure("Change password failed: $e"));
    }
  }
}
