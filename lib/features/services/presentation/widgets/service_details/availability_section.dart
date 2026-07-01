import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/features/services/data/models/service_details_model.dart';
import 'package:flutter/material.dart';

class AvailabilitySection extends StatelessWidget {
  final List<AvailabilityModel> availability;

  const AvailabilitySection({
    super.key,
    required this.availability,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: availability.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Working Hours

              Row(
                children: [

                  const Icon(
                    Icons.access_time_rounded,
                    color: AppColors.primary,
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

              /// Capacity

              Row(
                children: [

                  const Icon(
                    Icons.groups_rounded,
                    color: AppColors.primary,
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

              /// Working Days

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
                      color: AppColors.primary.withOpacity(.08),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      _formatDay(day.dayOfWeek),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );

                }).toList(),
              ),

              if (item.timeSlots.isNotEmpty) ...[

                const SizedBox(height: 22),

                const Divider(),

                const SizedBox(height: 16),

                Text(
                  "Available Time Slots",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                ...item.timeSlots.map(
                  (slot) {

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.05),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [

                          const Icon(
                            Icons.schedule,
                            color: AppColors.primary,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "${slot.fromTime} → ${slot.toTime}",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),

                          Text(
                            "${slot.capacity}",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );

                  },
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatDay(String day) {

    switch (day) {

      case "SUNDAY":
        return "Sunday";

      case "MONDAY":
        return "Monday";

      case "TUESDAY":
        return "Tuesday";

      case "WEDNESDAY":
        return "Wednesday";

      case "THURSDAY":
        return "Thursday";

      case "FRIDAY":
        return "Friday";

      case "SATURDAY":
        return "Saturday";

      default:
        return day;
    }
  }
}