
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

abstract class AuthRepository {
Future<Map<String, dynamic>> login(
    String email,
    String password,
  );  

   Future<RegisterResponseModel> register(
    RegisterRequestModel request,
  );
  Future<VerifyOtpResponseModel> verifyOtp(
  VerifyOtpRequestModel request,
);
Future<ResendOtpResponseModel> resendOtp(
    ResendOtpRequestModel request);

    Future<void> logout();
    Future<RequestResetPasswordResponseModel> requestResetPassword(
  RequestResetPasswordRequestModel request,
);
Future<ResetPasswordResponseModel> resetPassword(
  ResetPasswordRequestModel request,
);
Future<void> changePassword(ChangePasswordRequestModel request);
}
 