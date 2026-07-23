import 'package:flutter/material.dart';

class EventStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepNames;

  const EventStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepNames,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalSteps * 2 - 1, (i) {
            if (i.isOdd) {
              final lineDone = (i ~/ 2) + 1 < currentStep;
              return Container(
                width: 28,
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: lineDone ? theme.primaryColor : theme.dividerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }
            final step = (i ~/ 2) + 1;
            final done = step < currentStep;
            final active = step == currentStep;

            return Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done || active
                    ? theme.primaryColor
                    : theme.primaryColor.withOpacity(.12),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(.35),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: done
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 15)
                  : Text(
                      "$step",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: active
                            ? Colors.white
                            : theme.primaryColor.withOpacity(.5),
                      ),
                    ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stepNames[currentStep - 1],
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.primaryColor,
              ),
            ),
            Text(
              "Step $currentStep of $totalSteps",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(.55),
              ),
            ),
          ],
        ),
      ],
    );
  }
}