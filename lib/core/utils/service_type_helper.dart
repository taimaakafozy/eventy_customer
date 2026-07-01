import 'package:flutter/material.dart';

class ServiceTypeHelper {
  static String displayName(String type) {
    switch (type.toUpperCase()) {
      case "HALL":
        return "Venues";

      case "DECORATION":
        return "Decoration";

      case "FOOD":
        return "Catering";

      case "PHOTOGRAPHY":
        return "Photography";

      case "SOUND":
        return "Music";

      case "FAVORS":
        return "Favours";

      default:
        return type
            .toLowerCase()
            .split('_')
            .map(
              (e) => e[0].toUpperCase() + e.substring(1),
            )
            .join(' ');
    }
  }

  static IconData icon(String type) {
    switch (type.toUpperCase()) {
      case "HALL":
        return Icons.location_city_rounded;

      case "DECORATION":
        return Icons.auto_awesome_rounded;

      case "FOOD":
        return Icons.restaurant_rounded;

      case "PHOTOGRAPHY":
        return Icons.camera_alt_rounded;

      case "SOUND":
        return Icons.music_note_rounded;

      case "FAVORS":
        return Icons.card_giftcard_rounded;

      default:
        return Icons.category_rounded;
    }
  }
}