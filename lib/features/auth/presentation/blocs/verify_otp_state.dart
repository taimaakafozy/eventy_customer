abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  final String message;
  final String accessToken;
  final String refreshToken;

  VerifyOtpSuccess({
    required this.message,
    required this.accessToken,
    required this.refreshToken,
  });
}

class VerifyOtpError extends VerifyOtpState {
  final String message;

  VerifyOtpError(this.message);
}