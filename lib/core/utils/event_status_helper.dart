import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class EventStatusHelper {
  static String displayName(String status) {
    switch (status.toUpperCase()) {
      case "DRAFT":
        return "Draft";
      case "ACTIVE":
        return "Active";
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
      case "ACTIVE":
        return AppColors.success;
      case "IN_PROGRESS":
        return AppColors.primary;
      case "COMPLETED":
        return AppColors.secondary;
      case "CANCELLED":
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  static IconData icon(String status) {
    switch (status.toUpperCase()) {
      case "DRAFT":
        return Icons.edit_note_rounded;
      case "ACTIVE":
        return Icons.check_circle_rounded;
      case "IN_PROGRESS":
        return Icons.hourglass_top_rounded;
      case "COMPLETED":
        return Icons.task_alt_rounded;
      case "CANCELLED":
        return Icons.cancel_rounded;
      default:
        return Icons.circle;
    }
  }
} 