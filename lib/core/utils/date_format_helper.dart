class DateFormatHelper {
  /// يرجع التاريخ بصيغة 'yyyy-MM-dd' — تُستخدم لفلترة توفر الخدمة (query param: date)
  static String toIsoDateOnly(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}