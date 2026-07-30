class AddServiceBookingRequestModel {
  final String serviceId;
  final String? timeSlotId;
  final List<AddServiceBookingItem> items;

  AddServiceBookingRequestModel({
    required this.serviceId,
    this.timeSlotId,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        "serviceId": serviceId,
        if (timeSlotId != null) "timeSlotId": timeSlotId,
        "items": items.map((e) => e.toJson()).toList(),
      };
}

class AddServiceBookingItem {
  final String subServiceId;
  final int quantity;
  final String customerNotes;

  AddServiceBookingItem({
    required this.subServiceId,
    required this.quantity,
    required this.customerNotes,
  });

  Map<String, dynamic> toJson() => {
        "subServiceId": subServiceId,
        "quantity": quantity,
        "customerNotes": customerNotes,
      };
}

class AddedBookingModel {
  final String id;
  final String eventId;
  final String serviceId;
  final double totalAmount;
  final String status;

  AddedBookingModel({
    required this.id,
    required this.eventId,
    required this.serviceId,
    required this.totalAmount,
    required this.status,
  });

  factory AddedBookingModel.fromJson(Map<String, dynamic> json) {
    return AddedBookingModel(
      id: json['id'] ?? '',
      eventId: json['eventId'] ?? '',
      serviceId: json['serviceId'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
    );
  }
}