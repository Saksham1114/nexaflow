extension DateTimeExtension on DateTime {
  String get shortDate {
    return "$day/$month/$year";
  }

  String get shortTime {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');

    return "$h:$m";
  }
}
