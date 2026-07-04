import 'package:eventy_customer/core/utils/event_type_helper.dart';
import 'package:eventy_customer/features/services/data/models/service_details_model.dart';
import 'package:flutter/material.dart';

class EventTypesSection extends StatelessWidget {
  final List<EventTypeModel> eventTypes;

  const EventTypesSection({super.key, required this.eventTypes});

  @override
  Widget build(BuildContext context) {
    if (eventTypes.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: eventTypes.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(.08),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            EventTypeHelper.displayName(e.eventType),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }).toList(),
    );
  }
}