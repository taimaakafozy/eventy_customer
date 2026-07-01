import 'user_model.dart';

class ProviderModel {
  final String id;
  final String businessName;
  final String description;
  final UserModel user;

  const ProviderModel({
    required this.id,
    required this.businessName,
    required this.description,
    required this.user,
  });

  factory ProviderModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProviderModel(
      id: json['id'],
      businessName: json['businessName'],
      description: json['description'] ?? '',
      user: UserModel.fromJson(json['user']),
    );
  }
}