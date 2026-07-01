class WorkingDayModel {
  final String id;
  final String dayOfWeek;

  const WorkingDayModel({
    required this.id,
    required this.dayOfWeek,
  });

  factory WorkingDayModel.fromJson(Map<String, dynamic> json) {
    return WorkingDayModel(
      id: json['id'] ?? '',
      dayOfWeek: json['dayOfWeek'] ?? '',
    );
  }
}