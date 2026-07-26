import '../repositories/auth_repository.dart';
import '../../data/models/change_password_request_model.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> call(ChangePasswordRequestModel request) {
    return repository.changePassword(request);
  }
}