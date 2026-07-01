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
            .map(
              (e) => e.isEmpty
                  ? e
                  : "${e[0].toUpperCase()}${e.substring(1)}",
            )
            .join(" ");
    }
  }
}