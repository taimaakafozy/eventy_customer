import 'package:eventy_customer/features/services/data/models/discount_model.dart';

class SubServiceModel {
  final String id;
  final String name;
  final double pricePerUnit;
  final String unitType;
  final int dailyCapacity;
  final double? originalPrice;
final double? finalPrice;
final double discountAmount;
final DiscountModel? discount;

  const SubServiceModel({
    required this.id,
    required this.name,
    required this.pricePerUnit,
    required this.unitType,
    required this.dailyCapacity,
    this.originalPrice,
this.finalPrice,
this.discountAmount = 0,
this.discount,
  });

  factory SubServiceModel.fromJson(Map<String, dynamic> json) {
    return SubServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      pricePerUnit: (json['pricePerUnit'] ?? 0).toDouble(),
      unitType: json['unitType'] ?? '',
      dailyCapacity: json['dailyCapacity'] ?? 0,
      originalPrice: json['originalPrice']?.toDouble(),
finalPrice: json['finalPrice']?.toDouble(),
discountAmount: (json['discountAmount'] ?? 0).toDouble(),
discount: json['discount'] != null ? DiscountModel.fromJson(json['discount']) : null,

    );
  }
  bool get hasDiscount => discountAmount > 0;
}
