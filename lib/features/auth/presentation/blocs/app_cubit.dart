import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/secure_storage_service.dart';
abstract class AppState {}

class AppInitial extends AppState {} // loading

class AppAuthenticated extends AppState {}

class AppUnauthenticated extends AppState {}
class LogoutSuccess extends AppState {
  final String message;
  LogoutSuccess(this.message);
}

class LogoutError extends AppState {
  final String message;
  LogoutError(this.message);
}


class AppCubit extends Cubit<AppState> {
  final SecureStorageService storage;
  // final LogoutUseCase logoutUseCase;
  // String? role;

  AppCubit(this.storage,
  //  this.logoutUseCase
   ) : super(AppInitial());

  Future<void> checkAuth() async {
    final token = await storage.getToken();
    // role = await storage.getUserRole();
    if (token != null) {
      emit(AppAuthenticated());
    } else {
      emit(AppUnauthenticated());
    }
  }

  Future<void> logout() async {
    try {
      // await logoutUseCase();
      await storage.deleteToken();

      emit(LogoutSuccess("تم تسجيل الخروج بنجاح"));

      /// 🔥 أهم سطر: تحويل الحالة مباشرة لغير مسجل
      emit(AppUnauthenticated());
    } catch (e) {
      await storage.deleteToken();

      emit(LogoutError("تم تسجيل الخروج محلياً"));
      emit(AppUnauthenticated());
    }
  }
  // Future<String?> get role => storage.getUserRole();
}