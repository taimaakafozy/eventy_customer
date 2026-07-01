class ServiceTypeModel {
  final String name;

  const ServiceTypeModel({
    required this.name,
  });

  factory ServiceTypeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ServiceTypeModel(
      name: json['name'],
    );
  }
}