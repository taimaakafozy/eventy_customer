import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {

  final String title;
  final String message;
  final IconData icon;

  const EmptyView({
    super.key,
    this.title = "لا يوجد بيانات",
    this.message = "عند توفر بيانات ستظهر هنا",
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Icon(
              icon,
              size: 70,
              color: theme.disabledColor,
            ),

            const SizedBox(height: 16),

            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.disabledColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}