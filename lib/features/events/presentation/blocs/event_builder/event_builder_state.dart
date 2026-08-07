class SelectedSubService {
  final String id;
  final String name;
  final double pricePerUnit; // ⚠️ الآن هذا هو السعر النهائي (بعد الخصم)
  final double? originalPricePerUnit; // موجود فقط عند وجود خصم فعلي
  final double? percentOff;
  final String unitType;
  final int quantity;

  const SelectedSubService({
    required this.id,
    required this.name,
    required this.pricePerUnit,
    this.originalPricePerUnit,
    this.percentOff,
    required this.unitType,
    required this.quantity,
  });

  bool get hasDiscount => originalPricePerUnit != null && originalPricePerUnit! > pricePerUnit;

  SelectedSubService copyWith({int? quantity}) {
    return SelectedSubService(
      id: id,
      name: name,
      pricePerUnit: pricePerUnit,
      originalPricePerUnit: originalPricePerUnit,
      percentOff: percentOff,
      unitType: unitType,
      quantity: quantity ?? this.quantity,
    );
  }
}

class SelectedService {
  final String serviceId;
  final String serviceName;
  final Map<String, SelectedSubService> subServices;

  final double? wholeServicePrice; // نهائي
  final double? wholeServiceOriginalPrice;
  final double? wholeServicePercentOff;

  final String? timeSlotId;

  const SelectedService({
    required this.serviceId,
    required this.serviceName,
    required this.subServices,
    this.wholeServicePrice,
    this.wholeServiceOriginalPrice,
    this.wholeServicePercentOff,
    this.timeSlotId,
  });

  SelectedService copyWith({
    Map<String, SelectedSubService>? subServices,
    double? wholeServicePrice,
    String? timeSlotId,
  }) {
    return SelectedService(
      serviceId: serviceId,
      serviceName: serviceName,
      subServices: subServices ?? this.subServices,
      wholeServicePrice: wholeServicePrice ?? this.wholeServicePrice,
      wholeServiceOriginalPrice: wholeServiceOriginalPrice,
      wholeServicePercentOff: wholeServicePercentOff,
      timeSlotId: timeSlotId ?? this.timeSlotId,
    );
  }

  bool get isSelected => subServices.isNotEmpty || wholeServicePrice != null;
}