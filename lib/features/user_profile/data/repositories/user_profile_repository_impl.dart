import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_remote_data_source.dart';
import '../models/user_profile_model.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remote;

  UserProfileRepositoryImpl(this.remote);

  @override
  Future<UserProfileModel> getProfile() => remote.getProfile();
}