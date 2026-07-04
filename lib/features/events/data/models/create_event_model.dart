class CreateEventRequest {
  final String name;
  final String eventType;
  final DateTime eventDate;
  final String eventStartTime;
  final String eventEndTime;
  final String eventLocation;
  final int numberOfGuests;
  final String customerNotes;
  final List<CreateBookingService> services;

  CreateEventRequest({
    required this.name,
    required this.eventType,
    required this.eventDate,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.eventLocation,
    required this.numberOfGuests,
    required this.customerNotes,
    required this.services,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "eventType": eventType,
        "eventDate": eventDate.toUtc().toIso8601String(),
        "eventStartTime": eventStartTime,
        "eventEndTime": eventEndTime,
        "eventLocation": eventLocation,
        "numberOfGuests": numberOfGuests,
        "customerNotes": customerNotes,
        "services": services.map((e) => e.toJson()).toList(),
      };
}

class CreateBookingService {
  final String serviceId;
  final List<CreateBookingItem> items;

  CreateBookingService({
    required this.serviceId,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        "serviceId": serviceId,
        "items": items.map((e) => e.toJson()).toList(),
      };
}

class CreateBookingItem {
  final String subServiceId;
  final int quantity;
  final String customerNotes;

  CreateBookingItem({
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

/// ===============================================================
/// RESPONSE
/// ===============================================================

class CreateEventResponse {
  final CreatedEvent event;
  final List<CreatedBooking> bookings;

  CreateEventResponse({
    required this.event,
    required this.bookings,
  });

  factory CreateEventResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    return CreateEventResponse(
      event: CreatedEvent.fromJson(data["event"]),
      bookings: (data["bookings"] as List)
          .map((e) => CreatedBooking.fromJson(e))
          .toList(),
    );
  }
}

class CreatedEvent {
  final String id;
  final String name;
  final String eventType;
  final DateTime eventDate;
  final String eventStartTime;
  final String eventEndTime;
  final String eventLocation;
  final int numberOfGuests;
  final String customerNotes;
  final String status;

  CreatedEvent({
    required this.id,
    required this.name,
    required this.eventType,
    required this.eventDate,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.eventLocation,
    required this.numberOfGuests,
    required this.customerNotes,
    required this.status,
  });

  factory CreatedEvent.fromJson(Map<String, dynamic> json) {
    return CreatedEvent(
      id: json["id"],
      name: json["name"],
      eventType: json["eventType"],
      eventDate: DateTime.parse(json["eventDate"]),
      eventStartTime: json["eventStartTime"],
      eventEndTime: json["eventEndTime"],
      eventLocation: json["eventLocation"],
      numberOfGuests: json["numberOfGuests"],
      customerNotes: json["customerNotes"] ?? "",
      status: json["status"],
    );
  }
}

class CreatedBooking {
  final String id;
  final String serviceId;
  final String eventId;
  final double totalAmount;
  final String status;
  final List<CreatedBookingItem> items;

  CreatedBooking({
    required this.id,
    required this.serviceId,
    required this.eventId,
    required this.totalAmount,
    required this.status,
    required this.items,
  });

  factory CreatedBooking.fromJson(Map<String, dynamic> json) {
    return CreatedBooking(
      id: json["id"],
      serviceId: json["serviceId"],
      eventId: json["eventId"],
      totalAmount: (json["totalAmount"] as num).toDouble(),
      status: json["status"],
      items: (json["items"] as List)
          .map((e) => CreatedBookingItem.fromJson(e))
          .toList(),
    );
  }
}

class CreatedBookingItem {
  final String id;
  final String subServiceId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  CreatedBookingItem({
    required this.id,
    required this.subServiceId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory CreatedBookingItem.fromJson(Map<String, dynamic> json) {
    return CreatedBookingItem(
      id: json["id"],
      subServiceId: json["subServiceId"],
      quantity: json["quantity"],
      unitPrice: (json["unitPrice"] as num).toDouble(),
      totalPrice: (json["totalPrice"] as num).toDouble(),
    );
  }
}