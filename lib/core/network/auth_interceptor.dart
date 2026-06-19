import 'package:dio/dio.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/app_cubit.dart';

import '../di/service_locator.dart';
import '../services/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
bool _isRefreshing = false;

  AuthInterceptor(this.dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await sl<SecureStorageService>().getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

 @override
Future<void> onError(
  DioException err,
  ErrorInterceptorHandler handler,
) async {

  if (err.response?.statusCode != 401) {
    return handler.next(err);
  }

  if (_isRefreshing) {
    return handler.next(err);
  }

  _isRefreshing = true;

  try {
    final storage = sl<SecureStorageService>();

    final refreshToken =
        await storage.getRefreshToken();

    if (refreshToken == null) {
      throw Exception("No refresh token");
    }

    /*
      نستخدم Dio جديد بدون Interceptors
      حتى لا ندخل بحلقة لا نهائية
    */

    final refreshDio = Dio(
      BaseOptions(
        baseUrl: dio.options.baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    final response = await refreshDio.post(
      'auth/refresh',
      data: {
        "refreshToken": refreshToken,
      },
    );

    final data = response.data['data'];

    final newAccessToken =
        data['accessToken'];

    final newRefreshToken =
        data['refreshToken'];

    await storage.saveToken(
      newAccessToken,
    );

    await storage.saveRefreshToken(
      newRefreshToken,
    );

    /*
      إعادة تنفيذ الطلب القديم
    */

    final request = err.requestOptions;

    request.headers['Authorization'] =
        'Bearer $newAccessToken';

    final clonedResponse =
        await dio.fetch(request);

    return handler.resolve(
      clonedResponse,
    );
 } catch (e) {

  await sl<AppCubit>().logout(
    callApi: false,
  );

  return handler.next(err);

} finally {
    _isRefreshing = false;
  }
}
}