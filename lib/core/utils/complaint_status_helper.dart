import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ComplaintStatusHelper {
  static String displayName(String status) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return "Pending";
      case "IN_PROGRESS":
        return "In Progress";
      case "RESOLVED":
        return "Resolved";
      case "REJECTED":
        return "Rejected";
      default:
        return status;
    }
  }

  static Color color(String status) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return AppColors.warning;
      case "IN_PROGRESS":
        return AppColors.primary;
      case "RESOLVED":
        return AppColors.success;
      case "REJECTED":
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  static IconData icon(String status) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return Icons.hourglass_top_rounded;
      case "IN_PROGRESS":
        return Icons.autorenew_rounded;
      case "RESOLVED":
        return Icons.check_circle_rounded;
      case "REJECTED":
        return Icons.cancel_rounded;
      default:
        return Icons.circle;
    }
  }
}