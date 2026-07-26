import 'package:flutter/material.dart';

class EventTypeHelper {
  static String displayName(String type) {
    switch (type) {
      case "WEDDING":
        return "Wedding";
      case "ENGAGEMENT":
        return "Engagement";
      case "GRADUATION":
        return "Graduation";
      case "BIRTHDAY":
        return "Birthday";
      case "BABY_SHOWER":
        return "Baby Shower";
      case "ALL_EVENTS":
        return "All Events";
      default:
        return type
            .replaceAll("_", " ")
            .toLowerCase()
            .split(" ")
            .map((e) => e.isEmpty ? e : "${e[0].toUpperCase()}${e.substring(1)}")
            .join(" ");
    }
  }

  /// ⚠️ جديد: أيقونة مناسبة لنوع المناسبة — تُستخدم بكارد المناسبة
  static IconData icon(String type) {
    switch (type.toUpperCase()) {
      case "WEDDING":
        return Icons.favorite_rounded;
      case "ENGAGEMENT":
        return Icons.diamond_rounded;
      case "GRADUATION":
        return Icons.school_rounded;
      case "BIRTHDAY":
        return Icons.cake_rounded;
      case "BABY_SHOWER":
        return Icons.child_friendly_rounded;
      default:
        return Icons.celebration_rounded;
    }
  }
}