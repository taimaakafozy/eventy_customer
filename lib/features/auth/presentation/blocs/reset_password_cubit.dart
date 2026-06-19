import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../data/models/reset_password_request_model.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase resetPasswordUseCase;
  final SecureStorageService secureStorage;

  ResetPasswordCubit(
    this.resetPasswordUseCase,
    this.secureStorage,
  ) : super(ResetPasswordInitial());

  Future<void> resetPassword(
    ResetPasswordRequestModel request,
  ) async {
    try {
      emit(ResetPasswordLoading());

      final response =
          await resetPasswordUseCase(request);

      await secureStorage.saveToken(
        response.data.accessToken,
      );

      await secureStorage.saveRefreshToken(
        response.data.refreshToken,
      );

       print(
  "TOKEN SAVED: ${await secureStorage.getToken()}",
);

print(
  "REFRESH SAVED: ${await secureStorage.getRefreshToken()}",
);

      emit(
        ResetPasswordSuccess(
          message: response.message,
          accessToken: response.data.accessToken,
          refreshToken: response.data.refreshToken,
        ),
      );
    } on DioException catch (e) {
      emit(
        ResetPasswordError(
          e.response?.data["message"] ??
              "Something went wrong",
        ),
      );
    }
  }
}