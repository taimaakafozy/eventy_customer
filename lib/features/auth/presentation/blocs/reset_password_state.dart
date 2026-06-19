abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message;
  final String accessToken;
  final String refreshToken;

  ResetPasswordSuccess({
    required this.message,
    required this.accessToken,
    required this.refreshToken,
  });
}

class ResetPasswordError extends ResetPasswordState {
  final String message;

  ResetPasswordError(this.message);
}