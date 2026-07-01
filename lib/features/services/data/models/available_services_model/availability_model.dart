import 'time_slot_model.dart';
import 'working_day_model.dart';

class AvailabilityModel {
  final String id;
  final String workFromTime;
  final String workToTime;
  final int capacity;
  final bool hasSlots;

  final List<WorkingDayModel> workingDays;
  final List<TimeSlotModel> timeSlots;

  const AvailabilityModel({
    required this.id,
    required this.workFromTime,
    required this.workToTime,
    required this.capacity,
    required this.hasSlots,
    required this.workingDays,
    required this.timeSlots,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      id: json['id'] ?? '',
      workFromTime: json['workFromTime'] ?? '',
      workToTime: json['workToTime'] ?? '',
      capacity: json['capacity'] ?? 0,
      hasSlots: json['hasSlots'] ?? false,

      workingDays: (json['workingDays'] as List<dynamic>? ?? [])
          .map((e) => WorkingDayModel.fromJson(e))
          .toList(),

      timeSlots: (json['timeSlots'] as List<dynamic>? ?? [])
          .map((e) => TimeSlotModel.fromJson(e))
          .toList(),
    );
  }
}