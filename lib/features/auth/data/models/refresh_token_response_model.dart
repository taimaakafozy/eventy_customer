class RefreshTokenResponseModel {
  final String accessToken;
  final String refreshToken;

  const RefreshTokenResponseModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];

    return RefreshTokenResponseModel(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
    );
  }
}