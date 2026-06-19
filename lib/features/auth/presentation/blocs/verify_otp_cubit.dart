import 'package:dio/dio.dart';
import 'package:eventy_customer/core/services/secure_storage_service.dart';
import 'package:eventy_customer/features/auth/data/models/verify_otp_request_model.dart';
import 'package:eventy_customer/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final VerifyOtpUsecase verifyOtpUsecase;
  final SecureStorageService secureStorage;

  VerifyOtpCubit(this.verifyOtpUsecase, this.secureStorage)
    : super(VerifyOtpInitial());

  Future<void> verifyOtp(VerifyOtpRequestModel request) async {
    try {
      emit(VerifyOtpLoading());

      final response = await verifyOtpUsecase(request);

      /// حفظ التوكينات
      await secureStorage.saveToken(response.data.accessToken);

      await secureStorage.saveRefreshToken(response.data.refreshToken);
      print(
  "TOKEN SAVED: ${await secureStorage.getToken()}",
);

print(
  "REFRESH SAVED: ${await secureStorage.getRefreshToken()}",
);

      emit(
        VerifyOtpSuccess(
          message: response.message,
          accessToken: response.data.accessToken,
          refreshToken: response.data.refreshToken,
        ),
      );


    } on DioException catch (e) {
  print("STATUS: ${e.response?.statusCode}");
  print("DATA: ${e.response?.data}");

  emit(
    VerifyOtpError(
      e.response?.data["message"] ??
      "Something went wrong",
    ),
  );
}
  }
}
