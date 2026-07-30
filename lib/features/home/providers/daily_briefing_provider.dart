import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dashboard/providers/dashboard_provider.dart';
import '../../tasks/providers/task_provider.dart';
import '../models/daily_briefing.dart';

final dailyBriefingProvider = Provider<DailyBriefing>((ref) {
  final stats = ref.watch(dashboardStatsProvider);
  final tasks = ref.watch(taskProvider);

  final hour = DateTime.now().hour;

  String greeting;

  if (hour < 12) {
    greeting = "Good Morning ☀️";
  } else if (hour < 17) {
    greeting = "Good Afternoon 🌤";
  } else {
    greeting = "Good Evening 🌙";
  }

  final pending = stats.totalTasks - stats.completedTasks;

  String recommendation = "You're doing great today.";

  if (tasks.isNotEmpty) {
    recommendation =
        'Complete "${tasks.first.title}" first for maximum productivity.';
  }

  return DailyBriefing(
    greeting: greeting,
    summary:
        "You have $pending pending tasks and ${stats.completedHabits}/${stats.totalHabits} habits completed today.",
    recommendation: recommendation,
  );
});
