/// خصم على مستوى الخدمة أو الـ Sub-Service (من GET /services/available و GET /services/:id)
class DiscountModel {
  final String id;
  final String? code;
  final double percentOff;
  final String? origin; // PROVIDER | ADMIN ...

  DiscountModel({
    required this.id,
    this.code,
    required this.percentOff,
    this.origin,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'] ?? '',
      code: json['code'],
      percentOff: (json['percentOff'] ?? 0).toDouble(),
      origin: json['origin'],
    );
  }
}

/// خصم على مستوى الحجز (Booking) — شكل مختلف قليلاً (amount بدل origin)
class BookingDiscountModel {
  final String id;
  final String? code;
  final double percentOff;
  final double amount;

  BookingDiscountModel({
    required this.id,
    this.code,
    required this.percentOff,
    required this.amount,
  });

  factory BookingDiscountModel.fromJson(Map<String, dynamic> json) {
    return BookingDiscountModel(
      id: json['id'] ?? '',
      code: json['code'],
      percentOff: (json['percentOff'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}