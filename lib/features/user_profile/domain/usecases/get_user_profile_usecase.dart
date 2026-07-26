import '../../data/models/user_profile_model.dart';
import '../repositories/user_profile_repository.dart';

class GetUserProfileUseCase {
  final UserProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<UserProfileModel> call() => repository.getProfile();
}