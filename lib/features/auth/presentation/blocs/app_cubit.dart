import 'package:eventy_customer/features/auth/domain/usecases/logout_use_case.dart';
import 'package:eventy_customer/features/favorites/presentation/blocs/favorite_status/favorite_status_cubit.dart';
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
final FavoriteStatusCubit favoriteStatusCubit;
  AppCubit(
    this.storage,
     this.logoutUseCase,
     this.favoriteStatusCubit,
  ) : super(AppInitial()){
  print("APP CUBIT CREATED: ${identityHashCode(this)}");
}
 Future<void> checkAuth() async {
    final token = await storage.getToken();

    if (token != null && token.isNotEmpty) {
      emit(AppAuthenticated());
      await favoriteStatusCubit.loadFavoriteIds();
    } else {
      emit(AppUnauthenticated());
    }
  }

  void setAuthenticated() {
    emit(AppAuthenticated());
    favoriteStatusCubit.loadFavoriteIds();
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
      favoriteStatusCubit.clear();


    emit(LogoutSuccess("تم تسجيل الخروج بنجاح"));
    emit(AppUnauthenticated());
  } catch (e) {
    await storage.deleteToken();
    await storage.deleteRefreshToken();
    favoriteStatusCubit.clear();


    emit(LogoutError("تم تسجيل الخروج محلياً"));
    emit(AppUnauthenticated());
  }
}
}
