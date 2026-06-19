import '../repositories/auth_repository.dart';
import '../../data/models/request_reset_password_request_model.dart';

class RequestResetPasswordUseCase {
  final AuthRepository repository;

  RequestResetPasswordUseCase(this.repository);

  Future call(
    RequestResetPasswordRequestModel request,
  ) {
    return repository.requestResetPassword(request);
  }
}