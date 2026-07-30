import 'package:flutter/material.dart';

enum BookingChoice {
  existing,
  create,
}

class BookingChoiceSheet extends StatelessWidget {
  const BookingChoiceSheet({super.key});

  static Future<BookingChoice?> show(BuildContext context) {
    return showModalBottomSheet<BookingChoice>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const BookingChoiceSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add to which event?",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),

          _ChoiceTile(
            icon: Icons.event_available_rounded,
            title: "Add to Existing Event",
            subtitle: "Choose from your upcoming events",
            onTap: () {
              Navigator.pop(context, BookingChoice.existing);
            },
          ),

          const SizedBox(height: 12),

          _ChoiceTile(
            icon: Icons.add_circle_outline_rounded,
            title: "Create New Event",
            subtitle: "Start a new event and add this service",
            onTap: () {
              Navigator.pop(context, BookingChoice.create);
            },
          ),
        ],
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ChoiceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.primaryColor.withOpacity(.06),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: theme.primaryColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: theme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}