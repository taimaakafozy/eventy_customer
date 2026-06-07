abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String phone, String password);
  Future<bool> logout();
}
 