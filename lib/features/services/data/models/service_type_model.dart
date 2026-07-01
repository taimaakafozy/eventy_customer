class ServiceTypeModel {
  final String id;
  final String name;
  final String description;
  final int servicesCount;

  ServiceTypeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.servicesCount,
  });

  factory ServiceTypeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ServiceTypeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      servicesCount:
          json['_count']?['services'] ?? 0,
    );
  }
}