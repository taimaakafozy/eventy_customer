class ServiceFileModel {
  final String id;
  final String url;
  final String type;

  ServiceFileModel({
    required this.id,
    required this.url,
    required this.type,
  });

  factory ServiceFileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ServiceFileModel(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      type: json['type'] ?? '',
    );
  }
}