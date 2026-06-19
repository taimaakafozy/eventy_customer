class ResetPasswordResponseModel {
  final bool success;
  final String message;
  final ResetPasswordData data;

  ResetPasswordResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ResetPasswordResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ResetPasswordResponseModel(
      success: json["success"],
      message: json["message"],
      data: ResetPasswordData.fromJson(json["data"]),
    );
  }
}

class ResetPasswordData {
  final String accessToken;
  final String refreshToken;

  ResetPasswordData({
    required this.accessToken,
    required this.refreshToken,
  });

  factory ResetPasswordData.fromJson(
    Map<String, dynamic> json,
  ) {
    return ResetPasswordData(
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
    );
  }
}