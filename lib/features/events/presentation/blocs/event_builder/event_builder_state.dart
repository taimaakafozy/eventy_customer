class SelectedSubService {
  final String id;
  final String name;
  final double pricePerUnit;
  final String unitType;
  final int quantity;

  const SelectedSubService({
    required this.id,
    required this.name,
    required this.pricePerUnit,
    required this.unitType,
    required this.quantity,
  });

  SelectedSubService copyWith({int? quantity}) {
    return SelectedSubService(
      id: id,
      name: name,
      pricePerUnit: pricePerUnit,
      unitType: unitType,
      quantity: quantity ?? this.quantity,
    );
  }
}

class SelectedService {
  final String serviceId;
  final String serviceName;
  final Map<String, SelectedSubService> subServices;

  /// خدمات بدون Sub-Services (Hall/Sound) — وجود قيمة هنا يعني اختيار الخدمة كاملة
  final double? wholeServicePrice;

  /// ⚠️ أُعيدت إضافته: مطلوب من الباك اند فقط للخدمات التي تعتمد Time Slots
  /// (hasSlots = true) — يُحسب تلقائيًا بمطابقة وقت المناسبة مع الفتحات المتاحة،
  /// المستخدم لا يختاره يدويًا إطلاقًا.
  final String? timeSlotId;

  const SelectedService({
    required this.serviceId,
    required this.serviceName,
    required this.subServices,
    this.wholeServicePrice,
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
      timeSlotId: timeSlotId ?? this.timeSlotId,
    );
  }

  bool get isSelected => subServices.isNotEmpty || wholeServicePrice != null;
}