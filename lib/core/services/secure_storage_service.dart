import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }
   Future<void> saveRefreshToken(
    String refreshToken,
  ) async {
    await _storage.write(
      key: 'refreshToken',
      value: refreshToken,
    );
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(
      key: 'refreshToken',
    );
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(
      key: 'refreshToken',
    );
  }
}