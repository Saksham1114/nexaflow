import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../focus/providers/focus_statistics_provider.dart';
import '../../habits/providers/habit_provider.dart';
import '../../settings/providers/settings_provider.dart';
import '../../tasks/providers/task_provider.dart';
import '../../water/providers/water_provider.dart';
import '../models/dashboard_overview.dart';

export '../models/dashboard_overview.dart';

final dashboardProvider = Provider<DashboardOverview>((ref) {
  final tasks = ref.watch(taskProvider);
  final habits = ref.watch(habitProvider);
  final focus = ref.watch(focusStatisticsProvider);
  final waterEntries = ref.watch(waterProvider);
  final settings = ref.watch(settingsProvider);

  final completedTasks = tasks.where((t) => t.isCompleted).length;
  final completedHabits = habits.where((h) => h.completedToday).length;

  final taskScore = tasks.isEmpty ? 1.0 : completedTasks / tasks.length;
  final habitScore = habits.isEmpty ? 1.0 : completedHabits / habits.length;

  final totalWater = waterEntries.fold<int>(
    0,
    (sum, entry) => sum + entry.amount,
  );

  final waterGoal = settings.dailyGoal > 0 ? settings.dailyGoal : 3000;
  final waterScore = (totalWater / waterGoal).clamp(0.0, 1.0);

  final productivity = (taskScore + habitScore + waterScore) / 3;

  return DashboardOverview(
    completedTasks: completedTasks,
    totalTasks: tasks.length,
    completedHabits: completedHabits,
    totalHabits: habits.length,
    focusMinutes: focus.totalMinutes,
    waterConsumed: totalWater,
    waterGoal: waterGoal,
    productivity: productivity,
  );
});

// Alias for backward compatibility
final dashboardStatsProvider = dashboardProvider;
final dashboardOverviewProvider = dashboardProvider;

