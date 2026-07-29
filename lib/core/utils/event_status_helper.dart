import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EventStatusHelper {
  static String displayName(String status) {
    switch (status.toUpperCase()) {
      case "DRAFT":
        return "Draft";

      case "IN_PROGRESS":
        return "In Progress";

      case "COMPLETED":
        return "Completed";

      case "CANCELLED":
        return "Cancelled";

      default:
        return status;
    }
  }

  static Color color(String status) {
    switch (status.toUpperCase()) {
      case "DRAFT":
        return AppColors.warning;
      case "IN_PROGRESS":
        return AppColors.in_progress;
      case "COMPLETED":
        return AppColors.success;

      case "CANCELLED":
        return AppColors.error;

      default:
        return Colors.grey;
    }
  }

  static IconData icon(String status) {
    switch (status.toUpperCase()) {
      case "DRAFT":
        return Icons.edit_note_rounded;

      case "IN_PROGRESS":
        return Icons.autorenew_rounded;

      case "COMPLETED":
        return Icons.verified_rounded;

      case "CANCELLED":
        return Icons.cancel_rounded;

      default:
        return Icons.help_outline_rounded;
    }
  }
}
