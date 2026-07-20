import '../../tasks/models/task.dart';

class DailyFocus {
  const DailyFocus({
    required this.highPriority,
    required this.upcoming,
    required this.completedToday,
  });

  final List<Task> highPriority;
  final List<Task> upcoming;
  final int completedToday;
}
