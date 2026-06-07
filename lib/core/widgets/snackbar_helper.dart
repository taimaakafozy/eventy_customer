import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum SnackBarType {
  success,
  error,
  warning,
  info,
}

void showAppSnackBar(
  BuildContext context, {
  required String message,
  SnackBarType type = SnackBarType.success,
}) {

  Color backgroundColor;

  IconData icon;

  switch (type) {

    case SnackBarType.success:
      backgroundColor = AppColors.success;
      icon = Icons.check_circle_outline;
      break;

    case SnackBarType.error:
      backgroundColor = AppColors.error;
      icon = Icons.error_outline;
      break;

    case SnackBarType.warning:
      backgroundColor = AppColors.warning;
      icon = Icons.warning_amber_rounded;
      break;

    case SnackBarType.info:
      backgroundColor = AppColors.primary;
      icon = Icons.info_outline;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(

    SnackBar(

      backgroundColor: backgroundColor,

      behavior: SnackBarBehavior.floating,

      elevation: 0,

      margin: const EdgeInsets.all(16),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),

      duration: const Duration(seconds: 2),

      content: Row(
        children: [

          Icon(
            icon,
            color: Colors.white,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    ),
  );
}