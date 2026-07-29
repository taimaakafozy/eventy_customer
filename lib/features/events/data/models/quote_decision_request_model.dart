class QuoteDecisionRequestModel {
  final String eventId;
  final List<String> acceptedBookingIds;
  final String? method; // BANK_TRANSFER | CASH — إجباري فقط إذا فيه حجوزات مقبولة
  final List<String> rejectedBookingIds;
  final String? rejectionReason;

  QuoteDecisionRequestModel({
    required this.eventId,
    this.acceptedBookingIds = const [],
    this.method,
    this.rejectedBookingIds = const [],
    this.rejectionReason,
  });

  Map<String, dynamic> toJson() {
    return {
      "eventId": eventId,
      if (acceptedBookingIds.isNotEmpty) "acceptedBookingIds": acceptedBookingIds,
      if (acceptedBookingIds.isNotEmpty && method != null) "method": method,
      if (rejectedBookingIds.isNotEmpty) "rejectedBookingIds": rejectedBookingIds,
      if (rejectedBookingIds.isNotEmpty && rejectionReason != null && rejectionReason!.trim().isNotEmpty)
        "rejectionReason": rejectionReason,
    };
  }
}