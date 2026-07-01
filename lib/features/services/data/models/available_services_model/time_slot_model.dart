class TimeSlotModel {
  final String id;
  final String fromTime;
  final String toTime;
  final int capacity;

  const TimeSlotModel({
    required this.id,
    required this.fromTime,
    required this.toTime,
    required this.capacity,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] ?? '',
      fromTime: json['fromTime'] ?? '',
      toTime: json['toTime'] ?? '',
      capacity: json['capacity'] ?? 0,
    );
  }
}