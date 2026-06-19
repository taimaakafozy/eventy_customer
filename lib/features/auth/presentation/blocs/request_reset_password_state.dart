abstract class RequestResetPasswordState {}

class RequestResetPasswordInitial
    extends RequestResetPasswordState {}

class RequestResetPasswordLoading
    extends RequestResetPasswordState {}

class RequestResetPasswordSuccess
    extends RequestResetPasswordState {
  final String message;
  final String email;
  final String otp;

  RequestResetPasswordSuccess({
    required this.message,
    required this.email,
    required this.otp,
  });
}

class RequestResetPasswordError
    extends RequestResetPasswordState {
  final String message;

  RequestResetPasswordError(this.message);
}