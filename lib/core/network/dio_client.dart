import 'package:dio/dio.dart';
import 'package:eventy_customer/core/services/secure_storage_service.dart';

import 'auth_interceptor.dart';

class DioClient {
  final Dio dio;
  final SecureStorageService secureStorage;

  DioClient(this.secureStorage)
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://eventynour.com/api/v1/',
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(
      AuthInterceptor(dio),
    );
  }

  void testConnection() async {
    try {
      final response = await dio.get('/');

      print(response.data);
    } catch (e) {
      print('Connection failed: $e');
    }
  }
}