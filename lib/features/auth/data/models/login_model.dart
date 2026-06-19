class LoginModel {
  final bool success;
  final int statusCode;
  final String message;

  final String accessToken;
  final String refreshToken;

  LoginModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginModel(
      success: json['success'] ?? false,

      statusCode: json['statusCode'] ?? 0,

      message: json['message'] ?? '',

      accessToken:
          json['data']?['accessToken'] ?? '',

      refreshToken:
          json['data']?['refreshToken'] ?? '',
    );
  }
}