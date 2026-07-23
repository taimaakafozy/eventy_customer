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

  const SelectedService({
    required this.serviceId,
    required this.serviceName,
    required this.subServices,
  });
}