import '../repositories/auth_repository.dart';
import '../../data/models/reset_password_request_model.dart';
import '../../data/models/reset_password_response_model.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<ResetPasswordResponseModel> call(
    ResetPasswordRequestModel request,
  ) {
    return repository.resetPassword(request);
  }
}