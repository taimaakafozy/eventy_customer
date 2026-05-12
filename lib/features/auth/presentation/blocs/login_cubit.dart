
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  // final LoginUseCase loginUseCase;
  final SecureStorageService storage;

  LoginCubit(
    // this.loginUseCase,
   this.storage) : super(LoginInitial());

  Future<void> login(String phone, String password) async {
    emit(LoginLoading());

    // try {
    //   final result = await loginUseCase(phone, password);

    //   /// 👇 بدنا نرجّع التوكن + النوع
    //   final token = result['token'] as String;
    //   final role = result['role'] as String?;

    //   await storage.saveToken(token);
    //   // await storage.saveUserRole(role);
    //   if (role != null) {
    //     await storage.saveUserRole(role);
    //   } else {
    //     await storage.saveUserRole(''); // أو null handling
    //   }

    //   emit(LoginSuccess(token));
    // } catch (e) {
    //   emit(LoginError(e.toString().replaceAll('Exception: ', '')));
    //   print(e.toString());
    // }
  }
}