class RegisterResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final RegisterDataModel data;
  final String timestamp;

  RegisterResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory RegisterResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RegisterResponseModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: RegisterDataModel.fromJson(json['data']),
      timestamp: json['timestamp'],
    );
  }
}

class RegisterDataModel {
  final String email;
  final String otpCode;

  RegisterDataModel({
    required this.email,
    required this.otpCode,
  });

  factory RegisterDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RegisterDataModel(
      email: json['email'],
      otpCode: json['otpCode'],
    );
  }
}