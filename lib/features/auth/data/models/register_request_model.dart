import 'dart:io';

class RegisterRequestModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String? locationName;
  final double? longitude;
  final double? latitude;
  final File? profileImage;

  RegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.locationName,
    this.longitude,
    this.latitude,
    this.profileImage,
  });
}