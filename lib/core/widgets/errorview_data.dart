import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ErrorView extends StatelessWidget {

  final String title;
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.title = "حدث خطأ",
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            Icon(
              Icons.wifi_off_rounded,
              size: 70,
              color: AppColors.error,
            ),

            const SizedBox(height: 16),

            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.disabledColor,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: 180,

              child: ElevatedButton.icon(
                onPressed: onRetry,

                icon: const Icon(Icons.refresh),

                label: const Text("إعادة المحاولة"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}