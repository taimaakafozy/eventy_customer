import 'package:eventy_customer/core/utils/event_type_helper.dart';
import 'package:flutter/material.dart';

class _EventTypeOption {
  final String value;
  final IconData icon;
  const _EventTypeOption(this.value, this.icon);
}

const List<_EventTypeOption> _options = [
  _EventTypeOption("WEDDING", Icons.favorite_rounded),
  _EventTypeOption("ENGAGEMENT", Icons.diamond_rounded),
  _EventTypeOption("BIRTHDAY", Icons.cake_rounded),
  _EventTypeOption("GRADUATION", Icons.school_rounded),
  _EventTypeOption("BABY_SHOWER", Icons.child_friendly_rounded),
  _EventTypeOption("ALL_EVENTS", Icons.celebration_rounded),
];

class EventTypeSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;

  const EventTypeSelector({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final option = _options[index];
          final isSelected = option.value == selected;

          return GestureDetector(
            onTap: () => onSelect(option.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 78,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? theme.primaryColor.withOpacity(.12) : theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? theme.primaryColor : theme.dividerColor.withOpacity(.25),
                  width: isSelected ? 1.6 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(option.icon,
                      color: isSelected ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(.5),
                      size: 24),
                  const SizedBox(height: 6),
                  Text(
                    EventTypeHelper.displayName(option.value),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 10.5,
                      color: isSelected ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}