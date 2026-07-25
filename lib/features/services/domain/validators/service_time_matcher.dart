import 'package:eventy_customer/features/services/data/models/service_details_model.dart';

/// نتيجة مطابقة وقت المناسبة مع توفر الخدمة — شامل التحقق من Time Slots
/// إن وُجدت، أو ساعات العمل العامة إن لم توجد.
class ServiceTimeMatchResult {
  final bool fits;
  final String? timeSlotId;
  final String reason;

  const ServiceTimeMatchResult({
    required this.fits,
    this.timeSlotId,
    required this.reason,
  });
}

/// يطابق وقت المناسبة (eventStartTime -> eventEndTime) مع بيانات توفر الخدمة
/// المفلترة مسبقًا حسب تاريخ المناسبة (availability القادمة من الـ API بعد
/// تمرير query param: date، والتي تعكس فقط ذلك اليوم بالتحديد).
class ServiceTimeMatcher {
  static int _toMinutes(String hhmm) {
    final parts = hhmm.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  static bool _fitsWindow(int reqStart, int reqEnd, int winStart, int winEnd) {
    var rEnd = reqEnd;
    var wEnd = winEnd;
    if (rEnd <= reqStart) rEnd += 24 * 60; // مناسبة تمتد بعد منتصف الليل
    if (wEnd <= winStart) wEnd += 24 * 60; // نافذة عمل تمتد بعد منتصف الليل
    return reqStart >= winStart && rEnd <= wEnd;
  }

  static ServiceTimeMatchResult match({
    required List<AvailabilityModel> availability,
    required String eventStartTime,
    required String eventEndTime,
  }) {
    if (availability.isEmpty) {
      return const ServiceTimeMatchResult(
        fits: false,
        reason: "This service does not work on your event's date.",
      );
    }

    final reqStart = _toMinutes(eventStartTime);
    final reqEnd = _toMinutes(eventEndTime);

    for (final entry in availability) {
      if (entry.hasSlots) {
        for (final slot in entry.timeSlots) {
          final slotStart = _toMinutes(slot.fromTime);
          final slotEnd = _toMinutes(slot.toTime);
          if (_fitsWindow(reqStart, reqEnd, slotStart, slotEnd)) {
            return ServiceTimeMatchResult(
              fits: true,
              timeSlotId: slot.id,
              reason: "Matches available slot ${slot.fromTime} - ${slot.toTime}",
            );
          }
        }
      } else {
        final winStart = _toMinutes(entry.workFromTime);
        final winEnd = _toMinutes(entry.workToTime);
        if (_fitsWindow(reqStart, reqEnd, winStart, winEnd)) {
          return ServiceTimeMatchResult(
            fits: true,
            reason: "Within working hours ${entry.workFromTime} - ${entry.workToTime}",
          );
        }
      }
    }

    final hasSlots = availability.any((a) => a.hasSlots);

    if (hasSlots) {
      final slotsDesc =
          availability.expand((a) => a.timeSlots).map((s) => "${s.fromTime}-${s.toTime}").join(", ");
      return ServiceTimeMatchResult(
        fits: false,
        reason: slotsDesc.isEmpty
            ? "No time slots are available for this service on your event's date."
            : "Your event time ($eventStartTime-$eventEndTime) doesn't fit any available slot ($slotsDesc).",
      );
    }

    final windows = availability.map((a) => "${a.workFromTime}-${a.workToTime}").join(", ");
    return ServiceTimeMatchResult(
      fits: false,
      reason: "Your event time ($eventStartTime-$eventEndTime) is outside working hours ($windows).",
    );
  }
}