import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../habits/providers/habit_provider.dart';
import '../../tasks/providers/task_provider.dart';
import '../../water/providers/water_provider.dart';

class DashboardStats {
  const DashboardStats({
    required this.totalTasks,
    required this.completedTasks,
    required this.totalWater,
    required this.completedHabits,
    required this.totalHabits,
  });

  final int totalTasks;
  final int completedTasks;
  final int totalWater;
  final int completedHabits;
  final int totalHabits;

  double get productivity {
    final taskScore = totalTasks == 0 ? 0 : completedTasks / totalTasks;

    final habitScore = totalHabits == 0 ? 0 : completedHabits / totalHabits;

    final waterScore = (totalWater / 4000).clamp(0.0, 1.0);

    return ((taskScore + habitScore + waterScore) / 3);
  }
}

final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  final tasks = ref.watch(taskProvider);
  final habits = ref.watch(habitProvider);
  final water = ref.watch(waterProvider);

  final completedTasks = tasks.where((t) => t.isCompleted).length;

  final completedHabits = habits.where((h) => h.completedToday).length;

  final totalWater = water.fold<int>(0, (sum, e) => sum + e.amount);

  return DashboardStats(
    totalTasks: tasks.length,
    completedTasks: completedTasks,
    totalWater: totalWater,
    completedHabits: completedHabits,
    totalHabits: habits.length,
  );
});
