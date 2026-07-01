class EventTypeModel {
  final String eventType;

  const EventTypeModel({
    required this.eventType,
  });

  factory EventTypeModel.fromJson(Map<String, dynamic> json) {
    return EventTypeModel(
      eventType: json['eventType'] ?? '',
    );
  }
}