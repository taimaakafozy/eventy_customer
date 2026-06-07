import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
 
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
 
  AuthRepositoryImpl(this.remoteDataSource);
 
  @override
  Future<Map<String, dynamic>> login(String phone, String password) {
    return remoteDataSource.login(phone, password);
  }
 
  @override
  Future<bool> logout() {
    return remoteDataSource.logout();
  }
}
 