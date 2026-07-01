class SubServiceModel {
  final String id;
  final String name;
  final double pricePerUnit;
  final String unitType;
  final int dailyCapacity;

  const SubServiceModel({
    required this.id,
    required this.name,
    required this.pricePerUnit,
    required this.unitType,
    required this.dailyCapacity,
  });

  factory SubServiceModel.fromJson(Map<String, dynamic> json) {
    return SubServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      pricePerUnit: (json['pricePerUnit'] ?? 0).toDouble(),
      unitType: json['unitType'] ?? '',
      dailyCapacity: json['dailyCapacity'] ?? 0,
    );
  }
}