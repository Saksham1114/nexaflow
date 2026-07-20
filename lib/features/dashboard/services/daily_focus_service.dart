import '../../tasks/models/task.dart';
import '../models/daily_focus.dart';

class DailyFocusService {
  const DailyFocusService();

  DailyFocus generate(List<Task> tasks) {
    final highPriority = tasks
        .where((t) => t.priority == TaskPriority.high && !t.isCompleted)
        .toList();

    final upcoming = tasks
        .where((t) => t.hasDueDate && !t.isCompleted)
        .toList();

    final completed = tasks.where((t) => t.isCompleted).length;

    return DailyFocus(
      highPriority: highPriority,
      upcoming: upcoming,
      completedToday: completed,
    );
  }
}
