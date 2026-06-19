abstract class ResendOtpState {}

class ResendOtpInitial extends ResendOtpState {}

class ResendOtpLoading extends ResendOtpState {}

class ResendOtpSuccess extends ResendOtpState {
  final String message;
  final String email;
  final String otpCode;


  ResendOtpSuccess(this.message, this.email, this.otpCode);
}

class ResendOtpError extends ResendOtpState {
  final String message;

  ResendOtpError(this.message);
}