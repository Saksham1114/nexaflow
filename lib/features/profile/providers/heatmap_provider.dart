import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../focus/providers/focus_statistics_provider.dart';
import '../../habits/providers/habit_provider.dart';
import '../../tasks/providers/task_provider.dart';
import '../models/heatmap_day_data.dart';

class HeatmapMatrix {
  const HeatmapMatrix({
    required this.days,
    required this.totalActiveDays,
    required this.totalContributions,
    required this.currentStreak,
  });

  final Map<DateTime, HeatmapDayData> days;
  final int totalActiveDays;
  final int totalContributions;
  final int currentStreak;
}

final heatmapMatrixProvider = Provider<HeatmapMatrix>((ref) {
  final tasks = ref.watch(taskProvider);
  final habits = ref.watch(habitProvider);
  final focusStats = ref.watch(focusStatisticsProvider);

  final today = DateTime.now();
  final todayDateOnly = DateTime(today.year, today.month, today.day);

  // Generate 24 weeks (168 days) back up to Sunday of current week
  final daysFromMonday = (today.weekday - 1);
  final currentWeekStart = todayDateOnly.subtract(Duration(days: daysFromMonday));
  final startDate = currentWeekStart.subtract(const Duration(days: 23 * 7)); // 24 weeks total

  final Map<DateTime, HeatmapDayData> map = {};

  final totalDays = currentWeekStart.difference(startDate).inDays + 7;

  int totalActiveDays = 0;
  int totalContributions = 0;

  for (int i = 0; i < totalDays; i++) {
    final curDate = startDate.add(Duration(days: i));
    final curDateOnly = DateTime(curDate.year, curDate.month, curDate.day);

    int tasksDone = 0;
    for (final task in tasks) {
      if (task.isCompleted) {
        final taskDate = task.completedAt ?? task.createdAt;
        if (taskDate.year == curDateOnly.year &&
            taskDate.month == curDateOnly.month &&
            taskDate.day == curDateOnly.day) {
          tasksDone++;
        }
      }
    }

    int habitsDone = 0;
    for (final habit in habits) {
      if (habit.lastCompletedDate != null) {
        final hDate = habit.lastCompletedDate!;
        if (hDate.year == curDateOnly.year &&
            hDate.month == curDateOnly.month &&
            hDate.day == curDateOnly.day) {
          habitsDone++;
        }
      }
    }

    // Allocate focus minutes if matching today
    int focusMin = 0;
    if (curDateOnly == todayDateOnly) {
      focusMin = focusStats.totalMinutes;
    }

    final score = tasksDone * 2 + habitsDone + (focusMin > 0 ? 1 : 0);
    if (score > 0) {
      totalActiveDays++;
      totalContributions += score;
    }

    map[curDateOnly] = HeatmapDayData(
      date: curDateOnly,
      tasksCompleted: tasksDone,
      habitsCompleted: habitsDone,
      focusMinutes: focusMin,
      score: score,
    );
  }

  // Calculate current streak
  int streak = 0;
  var checkDate = todayDateOnly;
  while (true) {
    final data = map[checkDate];
    if (data != null && data.score > 0) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else {
      // If today has no activity yet, check yesterday to preserve ongoing streak
      if (checkDate == todayDateOnly) {
        checkDate = checkDate.subtract(const Duration(days: 1));
        final yesterdayData = map[checkDate];
        if (yesterdayData != null && yesterdayData.score > 0) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
          continue;
        }
      }
      break;
    }
  }

  return HeatmapMatrix(
    days: map,
    totalActiveDays: totalActiveDays,
    totalContributions: totalContributions,
    currentStreak: streak,
  );
});
