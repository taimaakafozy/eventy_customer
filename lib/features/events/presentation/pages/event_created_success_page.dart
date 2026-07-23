import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/widgets/primary_button.dart';
import 'package:eventy_customer/features/events/data/models/create_event_model.dart';
import 'package:flutter/material.dart';

class EventCreatedSuccessPage extends StatelessWidget {
  final CreateEventResponse response;

  const EventCreatedSuccessPage({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = response.event;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.hourglass_top_rounded, color: theme.primaryColor, size: 40),
              ),
              const SizedBox(height: 20),
              Text("Event Created! ⏳",
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                "Your bookings were submitted. Payment will be processed after all providers accept.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(.65),
                ),
              ),
              const SizedBox(height: 26),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.04),
                        blurRadius: 14,
                        offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Event Info",
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _row(theme, "Name", event.name),
                    _row(theme, "Date",
                        "${event.eventDate.year}-${event.eventDate.month.toString().padLeft(2, '0')}-${event.eventDate.day.toString().padLeft(2, '0')}"),
                    _row(theme, "Time", "${event.eventStartTime} - ${event.eventEndTime}"),
                    _row(theme, "Location", event.eventLocation),
                    _row(theme, "Guests", "${event.numberOfGuests}"),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.04),
                        blurRadius: 14,
                        offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bookings",
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    ...response.bookings.map((b) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text("Booking #${b.id.substring(0, 8)}",
                                  style: theme.textTheme.bodySmall),
                            ),
                            Text("\$${b.totalAmount.toStringAsFixed(0)}",
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withOpacity(.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                b.status,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                title: "Back to Home",
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.6))),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.end,
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}