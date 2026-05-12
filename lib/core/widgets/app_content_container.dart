import 'package:flutter/material.dart';
class AppContentContainer extends StatelessWidget {
  final Widget child;

  const AppContentContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(1),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 350),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.brightness == Brightness.dark
                  ? Colors.black26
                  : Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}