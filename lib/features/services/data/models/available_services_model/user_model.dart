class UserModel {
  final String fullName;
  final String? profileImage;
  final String? locationName;
  final String? phoneNumber;

  const UserModel({
    required this.fullName,
    this.profileImage,
    this.locationName,
    this.phoneNumber,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      fullName: json['fullName'] ?? '',
      profileImage: json['profileImage'],
      locationName: json['locationName'],
      phoneNumber: json['phoneNumber'],
    );
  }
}