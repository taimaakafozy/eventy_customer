class RequestResetPasswordRequestModel {
  final String email;

  RequestResetPasswordRequestModel({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
    };
  }
}