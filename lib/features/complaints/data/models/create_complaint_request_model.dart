class CreateComplaintRequestModel {
  final String targetType;
  final String? targetId;
  final String? bookingId;
  final String? packageBookingId;
  final String subject;
  final String description;

  CreateComplaintRequestModel({
    this.targetType = 'GENERAL',
    this.targetId,
    this.bookingId,
    this.packageBookingId,
    required this.subject,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "targetType": targetType,
      if (targetId != null) "targetId": targetId,
      if (bookingId != null) "bookingId": bookingId,
      if (packageBookingId != null) "packageBookingId": packageBookingId,
      "subject": subject,
      "description": description,
    };
  }
}