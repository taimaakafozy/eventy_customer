import 'package:eventy_customer/features/auth/domain/usecases/logout_use_case.dart';
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
  final LogoutUseCase logoutUseCase;
  // String? role;

  AppCubit(
    this.storage,
     this.logoutUseCase
  ) : super(AppInitial()){
  print("APP CUBIT CREATED: ${identityHashCode(this)}");
}
 Future<void> checkAuth() async {
    final token = await storage.getToken();

    if (token != null && token.isNotEmpty) {
      emit(AppAuthenticated());
    } else {
      emit(AppUnauthenticated());
    }
  }

  void setAuthenticated() {
    emit(AppAuthenticated());
  }

  void setUnauthenticated() {
    emit(AppUnauthenticated());
  }



 Future<void> logout({
  bool callApi = true,
}) async {
  try {
    if (callApi) {
      await logoutUseCase();
    }

    await storage.deleteToken();
    await storage.deleteRefreshToken();

    emit(LogoutSuccess("تم تسجيل الخروج بنجاح"));
    emit(AppUnauthenticated());
  } catch (e) {
    await storage.deleteToken();
    await storage.deleteRefreshToken();

    emit(LogoutError("تم تسجيل الخروج محلياً"));
    emit(AppUnauthenticated());
  }
}
}
