import 'package:flutter/material.dart';

class HeroBannerIndicator extends StatelessWidget {
  final int currentIndex;
  final int count;

  const HeroBannerIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isSelected = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isSelected ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor.withOpacity(.5),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}
