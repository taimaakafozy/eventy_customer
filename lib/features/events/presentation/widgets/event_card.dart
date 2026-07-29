import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/utils/date_format_helper.dart';
import 'package:eventy_customer/core/utils/event_status_helper.dart';
import 'package:eventy_customer/core/utils/event_type_helper.dart';
import 'package:eventy_customer/features/events/data/models/get_all_events_model.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final EventItem event;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = EventStatusHelper.color(event.status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      EventTypeHelper.icon(event.eventType),
                      color: theme.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          EventTypeHelper.displayName(event.eventType),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(.55),
                          ),
                        ),
                      ],
                    ), 
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(   
                      color: statusColor.withOpacity(.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          EventStatusHelper.icon(event.status),
                          size: 12,
                          color: statusColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          EventStatusHelper.displayName(event.status),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(height: 1, color: AppColors.gold),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.calendar_today_rounded,
                text:
                    "${DateFormatHelper.toDisplayDate(event.eventDate)} · ${event.eventStartTime} - ${event.eventEndTime}",
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.location_on_rounded,
                text: event.eventLocation,
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.groups_rounded,
                text: "${event.numberOfGuests} guests",
              ),
              if (event.customerNotes.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    event.customerNotes,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurface.withOpacity(.7),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 15, color: theme.colorScheme.primary.withOpacity(.8)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(.7),
            ),
          ),
        ),
      ],
    );
  }
}
