import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  final SecureStorageService storage;

  LoginCubit(
    this.loginUseCase,
    this.storage,
  ) : super(LoginInitial());

 Future<void> login(String email, String password) async {
  emit(LoginLoading());

  try {
    final result = await loginUseCase(email, password);
    final accessToken = result['accessToken'] as String;
    final refreshToken = result['refreshToken'] as String;

    await storage.saveToken(accessToken);
    await storage.saveRefreshToken(refreshToken);

    emit(LoginSuccess(accessToken));
  } catch (e) {
    emit(LoginError(e.toString().replaceFirst('Exception: ', '')));
    print(e.toString());
  }

  }
}