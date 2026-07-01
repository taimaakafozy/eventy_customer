class WeekDayHelper {
  static String displayName(String value) {
    switch (value) {
      case "SUNDAY":
        return "Sunday";

      case "MONDAY":
        return "Monday";

      case "TUESDAY":
        return "Tuesday";

      case "WEDNESDAY":
        return "Wednesday";

      case "THURSDAY":
        return "Thursday";

      case "FRIDAY":
        return "Friday";

      case "SATURDAY":
        return "Saturday";

      default:
        return value;
    }
  }
}