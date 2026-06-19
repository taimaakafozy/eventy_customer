class RequestResetPasswordResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final RequestResetPasswordData data;
  final String timestamp;

  RequestResetPasswordResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory RequestResetPasswordResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RequestResetPasswordResponseModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: RequestResetPasswordData.fromJson(json['data']),
      timestamp: json['timestamp'],
    );
  }
}

class RequestResetPasswordData {
  final String email;
  final String otp;

  RequestResetPasswordData({
    required this.email,
    required this.otp,
  });

  factory RequestResetPasswordData.fromJson(
    Map<String, dynamic> json,
  ) {
    return RequestResetPasswordData(
      email: json['email'],
      otp: json['otp'],
    );
  }
}