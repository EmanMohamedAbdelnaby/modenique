
abstract class AuthState{}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(this.message);
}

class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);
}

class AuthLoggedOut extends AuthState {
  final String message;
  AuthLoggedOut(this.message);
}

class AuthVerificationSent extends AuthState {}

class AuthCodeVerified extends AuthState {}
class OTPResendSuccess extends AuthState {
  final String message;
  OTPResendSuccess(this.message);
}




