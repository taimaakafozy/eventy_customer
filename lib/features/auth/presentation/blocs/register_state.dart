abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;
  final String email;
  final String otpCode;

  RegisterSuccess({
    required this.message,
    required this.email,
    required this.otpCode,
  });
}

class RegisterError extends RegisterState {
  final String message;

  RegisterError(this.message);
}