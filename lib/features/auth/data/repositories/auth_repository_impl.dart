import 'package:eventy_customer/features/auth/data/models/change_password_request_model.dart';
import 'package:eventy_customer/features/auth/data/models/register_request_model.dart';
import 'package:eventy_customer/features/auth/data/models/register_response_model.dart';
import 'package:eventy_customer/features/auth/data/models/request_reset_password_request_model.dart';
import 'package:eventy_customer/features/auth/data/models/request_reset_password_response_model.dart';
import 'package:eventy_customer/features/auth/data/models/resend_otp_request_model.dart';
import 'package:eventy_customer/features/auth/data/models/resend_otp_response_model.dart';
import 'package:eventy_customer/features/auth/data/models/reset_password_request_model.dart';
import 'package:eventy_customer/features/auth/data/models/reset_password_response_model.dart';
import 'package:eventy_customer/features/auth/data/models/verify_otp_request_model.dart';
import 'package:eventy_customer/features/auth/data/models/verify_otp_response_model.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl
    implements AuthRepository {

  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    return await remote.login(
      email,
      password,
    );
  }

  @override
Future<RegisterResponseModel> register(
  RegisterRequestModel request,
) async {
  return await remote.register(request);
}

  @override
  Future<VerifyOtpResponseModel> verifyOtp(
    VerifyOtpRequestModel request,
  ) async {
    return await remote.verifyOtp(request);
  }

  @override
Future<ResendOtpResponseModel> resendOtp(
    ResendOtpRequestModel request,
) {
  return remote.resendOtp(request);
}

@override
Future<void> logout() {
  return remote.logout();
}

@override
Future<RequestResetPasswordResponseModel> requestResetPassword(
  RequestResetPasswordRequestModel request,
) {
  return remote.requestResetPassword(request);
}

@override
Future<ResetPasswordResponseModel> resetPassword(
  ResetPasswordRequestModel request,
) {
  return remote.resetPassword(request);
}

@override
Future<void> changePassword(ChangePasswordRequestModel request) {
  return remote.changePassword(request);
}
}