import 'package:eventy_customer/features/auth/data/models/register_request_model.dart';
import 'package:eventy_customer/features/auth/data/models/register_response_model.dart';
import 'package:eventy_customer/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;

  const RegisterUsecase(this.repository);
 Future<RegisterResponseModel> call(
    RegisterRequestModel request,
  ) {
    return repository.register(request);
  }
}