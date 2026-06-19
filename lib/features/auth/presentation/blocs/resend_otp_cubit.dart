import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/resend_otp_request_model.dart';
import '../../domain/usecases/resend_otp_usecase.dart';

import 'resend_otp_state.dart';

class ResendOtpCubit extends Cubit<ResendOtpState> {
  final ResendOtpUsecase resendOtpUsecase;

  ResendOtpCubit(this.resendOtpUsecase)
      : super(ResendOtpInitial());

  Future<void> resendOtp(ResendOtpRequestModel request) async {
    try {
      emit(ResendOtpLoading());

      final response = await resendOtpUsecase(
        request,
      );

      emit(
        ResendOtpSuccess(response.message, response.data.email, response.data.otpCode),
      );
    } catch (e) {
      emit(
        ResendOtpError(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );

      print("RESEND OTP ERROR: $e");
    }
  }
}