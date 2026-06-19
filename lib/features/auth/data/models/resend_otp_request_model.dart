class ResendOtpRequestModel {
  final String email;

  const ResendOtpRequestModel({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
    };
  }
}