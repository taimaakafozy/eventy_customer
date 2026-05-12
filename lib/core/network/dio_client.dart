import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../services/secure_storage_service.dart';


class DioClient {
  late final Dio dio;
  final SecureStorageService storage;

  DioClient(this.storage) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://161.35.17.235:3000/graphql',
        headers: {'Content-Type': 'application/json'},
      ),
    );

    /// 🔥 إضافة التوكن تلقائياً
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.getToken();

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );
  }



  Future<Response> postQuery(String query, {
    Map<String, dynamic>? variables,
  }) async {
    try {
      final response = await dio.post(
        '',
        data: {
          "query": query,
          if (variables != null) "variables": variables,
        },
      );

      debugPrint("GraphQL Response: ${response.data}");

      if (response.data['errors'] != null) {
        final message = response.data['errors'][0]['message'];
        throw Exception(message);
      }

      return response;
    } on DioException catch (e) {
      debugPrint("Dio Error: ${e.response?.data}");

      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            "Network error",
      );
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      throw Exception(e.toString());
    }
  }
}
