class VerifyOtpResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final VerifyOtpData data;

  VerifyOtpResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory VerifyOtpResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return VerifyOtpResponseModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: VerifyOtpData.fromJson(json['data']),
    );
  }
}

class VerifyOtpData {
  final String accessToken;
  final String refreshToken;

  VerifyOtpData({
    required this.accessToken,
    required this.refreshToken,
  });

  factory VerifyOtpData.fromJson(
    Map<String, dynamic> json,
  ) {
    return VerifyOtpData(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}