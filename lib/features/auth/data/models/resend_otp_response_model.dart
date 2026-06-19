class ResendOtpResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final ResendOtpData data;
  final String timestamp;

  const ResendOtpResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponseModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: ResendOtpData.fromJson(json['data']),
      timestamp: json['timestamp'],
    );
  }
}

class ResendOtpData {
  final String email;
  final String otpCode;

  const ResendOtpData({
    required this.email,
    required this.otpCode,
  });

  factory ResendOtpData.fromJson(Map<String, dynamic> json) {
    return ResendOtpData(
      email: json['email'],
      otpCode: json['otpCode'],
    );
  }
}