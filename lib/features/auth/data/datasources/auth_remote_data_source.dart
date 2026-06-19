import 'dart:async';

import 'package:dio/dio.dart';
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

import '../../../../core/network/dio_client.dart';

abstract class AuthRemoteDataSource {
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
// Future<RefreshTokenResponseModel> refreshToken();
Future<void> logout();

Future<RequestResetPasswordResponseModel> requestResetPassword(
  RequestResetPasswordRequestModel request,
);
Future<ResetPasswordResponseModel> resetPassword(
  ResetPasswordRequestModel request,
);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await client.dio.post(
      'auth/login',
      data: {
        "email": email,
        "password": password,
      },
    );

    final data = response.data;

    if (data['success'] != true) {
      throw Exception(
        data['message'] ?? 'Login failed',
      );
    }

    return {
      "accessToken": data['data']['accessToken'],
      "refreshToken": data['data']['refreshToken'],
      "message": data['message'],
    };
  }

  @override
Future<RegisterResponseModel> register(
  RegisterRequestModel request,
) async {
  final formData = FormData.fromMap({
    "fullName": request.fullName,
    "email": request.email,
    "phoneNumber": request.phoneNumber,
    "password": request.password,
    "locationName": request.locationName,
    "longitude": request.longitude,
    "latitude": request.latitude,

    if (request.profileImage != null)
      "profileImage": await MultipartFile.fromFile(
        request.profileImage!.path,
        filename: request.profileImage!.path.split('/').last,
      ),
  });

  final response = await client.dio.post(
    'auth/register',
    data: formData,
  );

  final data = response.data;

  if (data['success'] != true) {
    throw Exception(
      data['message'] ?? 'Registration failed',
    );
  }

  return RegisterResponseModel.fromJson(data);
}

@override
Future<VerifyOtpResponseModel> verifyOtp(
  VerifyOtpRequestModel request,
) async {
  print("VERIFY OTP REQUEST: ${request.toJson()}");
  final response = await client.dio.post(
    'auth/verify-otp',
    data: request.toJson(),
  );

  final data = response.data;

  if (data['success'] != true) {
    throw Exception(
      data['message'] ?? 'OTP verification failed',
    );
  }

  return VerifyOtpResponseModel.fromJson(data);
}

@override
Future<ResendOtpResponseModel> resendOtp(
    ResendOtpRequestModel request,
) async {
  final response = await client.dio.post(
    '/auth/resend-otp',
    data: request.toJson(),
  );

  return ResendOtpResponseModel.fromJson(response.data);
}

// @override
// Future<RefreshTokenResponseModel> refreshToken() async {
//   throw UnimplementedError();
// }
@override
Future<void> logout() async {
  final refreshToken =
      await client.secureStorage.getRefreshToken();

  if (refreshToken == null) {
    return;
  }

  await client.dio.post(
    'auth/logout',
    data: {
      "refreshToken": refreshToken,
    },
  );
}

@override
Future<RequestResetPasswordResponseModel> requestResetPassword(
  RequestResetPasswordRequestModel request,
) async {
  final response = await client.dio.post(
    'auth/reset-password/request',
    data: request.toJson(),
  );

  return RequestResetPasswordResponseModel.fromJson(
    response.data,
  );
}

@override
Future<ResetPasswordResponseModel> resetPassword(
  ResetPasswordRequestModel request,
) async {
  final response = await client.dio.post(
    '/auth/reset-password/confirm',
    data: request.toJson(),
  );

  final data = response.data;

  if (data['success'] != true) {
    throw Exception(
      data['message'] ?? 'Password reset failed',
    );
  }

  return ResetPasswordResponseModel.fromJson(data);
}

}