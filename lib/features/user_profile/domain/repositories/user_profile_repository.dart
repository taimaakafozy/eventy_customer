import '../../data/models/user_profile_model.dart';

abstract class UserProfileRepository {
  Future<UserProfileModel> getProfile();
}