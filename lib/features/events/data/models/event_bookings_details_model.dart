class EventBookingsDetailsResponseModel {
  final EventBookingsDetailsModel data;

  EventBookingsDetailsResponseModel({required this.data});

  factory EventBookingsDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return EventBookingsDetailsResponseModel(data: EventBookingsDetailsModel.fromJson(json['data']));
  }
}

class EventBookingsDetailsModel {
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
  final DateTime createdAt;
  final List<BookingDetailModel> bookings;

  EventBookingsDetailsModel({
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
    required this.createdAt,
    required this.bookings,
  });

  factory EventBookingsDetailsModel.fromJson(Map<String, dynamic> json) {
    return EventBookingsDetailsModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      eventType: json['eventType'] ?? '',
      eventDate: DateTime.parse(json['eventDate']),
      eventStartTime: json['eventStartTime'] ?? '',
      eventEndTime: json['eventEndTime'] ?? '',
      eventLocation: json['eventLocation'] ?? '',
      numberOfGuests: json['numberOfGuests'] ?? 0,
      customerNotes: json['customerNotes'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      bookings: (json['bookings'] as List<dynamic>? ?? [])
          .map((e) => BookingDetailModel.fromJson(e))
          .toList(),
    );
  }

  List<BookingDetailModel> get quoteSentBookings =>
      bookings.where((b) => b.status.toUpperCase() == "QUOTE_SENT").toList();

  List<BookingDetailModel> get pendingBookings =>
      bookings.where((b) => b.status.toUpperCase() == "PENDING").toList();

  bool get hasAnyDecisionPending => quoteSentBookings.isNotEmpty;

  /// ⚠️ جديد: هل يوجد حجز مؤكد بدفعة كاش لسا بانتظار مسح المزوّد لل QR؟
  bool get hasProcessingCashPayments =>
      bookings.any((b) => b.payment != null && b.payment!.isCash && !b.payment!.isPaid);
}

class BookingDetailModel {
  final String id;
  final String serviceId;
  final String providerId;
  final double totalAmount;
  final double? finalAmount;
  final String status;
  final String? rejectionReason;
  final DateTime? cancellationDeadline;
  final BookingServiceModel service;
  final BookingProviderModel provider;
  final List<BookingItemModel> items;
  final BookingPaymentModel? payment;

  BookingDetailModel({
    required this.id,
    required this.serviceId,
    required this.providerId,
    required this.totalAmount,
    this.finalAmount,
    required this.status,
    this.rejectionReason,
    this.cancellationDeadline,
    required this.service,
    required this.provider,
    required this.items,
    this.payment,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailModel(
      id: json['id'] ?? '',
      serviceId: json['serviceId'] ?? '',
      providerId: json['providerId'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      finalAmount: json['finalAmount']?.toDouble(),
      status: json['status'] ?? '',
      rejectionReason: json['rejectionReason'],
      cancellationDeadline:
          json['cancellationDeadline'] != null ? DateTime.tryParse(json['cancellationDeadline']) : null,
      service: BookingServiceModel.fromJson(json['service'] ?? {}),
      provider: BookingProviderModel.fromJson(json['provider'] ?? {}),
      items: (json['items'] as List<dynamic>? ?? []).map((e) => BookingItemModel.fromJson(e)).toList(),
      payment: json['payment'] != null ? BookingPaymentModel.fromJson(json['payment']) : null,
    );
  }

  double get displayAmount => finalAmount ?? totalAmount;
}

class BookingServiceModel {
  final String id;
  final String description;
  final String? serviceLogo;
  final String serviceTypeName;

  BookingServiceModel({
    required this.id,
    required this.description,
    this.serviceLogo,
    required this.serviceTypeName,
  });

  factory BookingServiceModel.fromJson(Map<String, dynamic> json) {
    return BookingServiceModel(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      serviceLogo: json['serviceLogo'],
      serviceTypeName: json['serviceType']?['name'] ?? '',
    );
  }
}

class BookingProviderModel {
  final String id;
  final String businessName;
  final String? phoneNumber;

  BookingProviderModel({required this.id, required this.businessName, this.phoneNumber});

  factory BookingProviderModel.fromJson(Map<String, dynamic> json) {
    return BookingProviderModel(
      id: json['id'] ?? '',
      businessName: json['businessName'] ?? '',
      phoneNumber: json['user']?['phoneNumber'],
    );
  }
}

class BookingItemModel {
  final String subServiceId;
  final int quantity;
  final double unitPrice;
  final double? finalUnitPrice;
  final double totalPrice;
  final double? finalTotalPrice;
  final String name;
  final String unitType;

  BookingItemModel({
    required this.subServiceId,
    required this.quantity,
    required this.unitPrice,
    this.finalUnitPrice,
    required this.totalPrice,
    this.finalTotalPrice,
    required this.name,
    required this.unitType,
  });

  factory BookingItemModel.fromJson(Map<String, dynamic> json) {
    return BookingItemModel(
      subServiceId: json['subServiceId'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      finalUnitPrice: json['finalUnitPrice']?.toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      finalTotalPrice: json['finalTotalPrice']?.toDouble(),
      name: json['subService']?['name'] ?? '',
      unitType: json['subService']?['unitType'] ?? '',
    );
  }

  double get displayTotal => finalTotalPrice ?? totalPrice;
}

/// ⚠️ محدّث حسب الأشكال الثلاثة الفعلية من الباك اند
class BookingPaymentModel {
  final String id;
  final String method; // CASH | BANK_TRANSFER
  final String status; // PAID | PROCESSING
  final ProviderLocationModel? providerLocation;

  BookingPaymentModel({
    required this.id,
    required this.method,
    required this.status,
    this.providerLocation,
  });

  factory BookingPaymentModel.fromJson(Map<String, dynamic> json) {
    return BookingPaymentModel(
      id: json['id'] ?? '',
      method: json['method'] ?? '',
      status: json['status'] ?? '',
      providerLocation:
          json['providerLocation'] != null ? ProviderLocationModel.fromJson(json['providerLocation']) : null,
    );
  }

  bool get isPaid => status.toUpperCase() == 'PAID';
  bool get isCash => method.toUpperCase() == 'CASH';
  bool get isBankTransfer => method.toUpperCase() == 'BANK_TRANSFER';
}

class ProviderLocationModel {
  final double latitude;
  final double longitude;
  final String locationName;

  ProviderLocationModel({required this.latitude, required this.longitude, required this.locationName});

  factory ProviderLocationModel.fromJson(Map<String, dynamic> json) {
    return ProviderLocationModel(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      locationName: json['locationName'] ?? '',
    );
  }
}