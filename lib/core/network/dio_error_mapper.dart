import 'package:dio/dio.dart';

class DioErrorMapper {
  static Exception map(DioException e, {String fallback = "Something went wrong"}) {
    final data = e.response?.data;

    if (data is Map && data['message'] != null) {
      return Exception(data['message'].toString());
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception("Connection timed out. Please check your internet and try again.");
      case DioExceptionType.connectionError:
        return Exception("No internet connection. Please try again.");
      default:
        return Exception(fallback);
    }
  }
}