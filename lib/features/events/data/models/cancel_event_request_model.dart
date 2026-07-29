class CancelEventRequestModel {
  final String reason;

  CancelEventRequestModel({
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      "reason": reason,
    };
  }
}