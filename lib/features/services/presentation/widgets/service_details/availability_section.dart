import 'package:eventy_customer/core/utils/week_day_helper.dart';
import 'package:eventy_customer/features/services/data/models/service_details_model.dart';
import 'package:flutter/material.dart';

class AvailabilitySection extends StatelessWidget {
  final List<AvailabilityModel> availability;

  const AvailabilitySection({super.key, required this.availability});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: availability.map((item) {
        /// عندما تتوفر Time Slots محددة، لا داعي لعرض
        /// وقت الدوام الكلي أو السعة الإجمالية — الـ Slots هي المصدر الوحيد للمعلومة
        final bool showGeneralInfo = !item.hasSlots;

        return Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(.04),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ==========================
              /// General working hours + capacity
              /// (تظهر فقط عندما لا توجد Time Slots محددة)
              /// ==========================
              if (showGeneralInfo) ...[
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: theme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${item.workFromTime} - ${item.workToTime}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Icon(
                      Icons.groups_rounded,
                      color: theme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Capacity : ${item.capacity}",
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),

                const SizedBox(height: 18),
              ],

              /// ==========================
              /// Working Days (يظهر دائماً)
              /// ==========================
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.workingDays.map((day) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(.08),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      WeekDayHelper.displayName(day.dayOfWeek),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),

              /// ==========================
              /// Time Slots (تظهر فقط عند hasSlots == true)
              /// ==========================
              if (item.hasSlots && item.timeSlots.isNotEmpty) ...[
                const SizedBox(height: 22),
                Divider(color: theme.dividerColor),
                const SizedBox(height: 16),

                Text(
                  "Available Time Slots",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                ...item.timeSlots.map((slot) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(.05),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.schedule_rounded, color: theme.primaryColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "${slot.fromTime} → ${slot.toTime}",
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Capacity: ${slot.capacity}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
