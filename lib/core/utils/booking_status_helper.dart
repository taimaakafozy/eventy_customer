import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class BookingStatusHelper {
  static String displayName(String status) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return "Pending";

      case "QUOTE_SENT":
        return "Quote Sent";

      case "CONFIRMED":
        return "Confirmed";

      case "IN_PROGRESS":
        return "In Progress";

      case "COMPLETED":
        return "Completed";

      case "REJECTED":
        return "Rejected";

      case "CANCELLED":
        return "Cancelled";

      default:
        return status;
    }
  }

  static Color color(String status) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return AppColors.warning;

      case "QUOTE_SENT":
        return AppColors.primary;

      case "CONFIRMED":
        return AppColors.success;

      case "IN_PROGRESS":
        return AppColors.in_progress;

      case "COMPLETED":
        return AppColors.success;

      case "REJECTED":
        return AppColors.error;

      case "CANCELLED":
        return AppColors.error;

      default:
        return Colors.grey;
    }
  }

  static IconData icon(String status) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return Icons.schedule_rounded;

      case "QUOTE_SENT":
        return Icons.request_quote_rounded;

      case "CONFIRMED":
        return Icons.check_circle_rounded;

      case "IN_PROGRESS":
        return Icons.autorenew_rounded;

      case "COMPLETED":
        return Icons.verified_rounded;

      case "REJECTED":
        return Icons.close_rounded;

      case "CANCELLED":
        return Icons.cancel_rounded;

      default:
        return Icons.help_outline_rounded;
    }
  }
}