import '../models/task.dart';

extension TaskExtensions on Task {
  bool get isToday {
    final now = DateTime.now();

    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  bool get isUpcoming {
    if (dueDate == null) return false;

    return dueDate!.isAfter(DateTime.now());
  }
}
