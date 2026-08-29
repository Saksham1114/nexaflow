import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dashboard/providers/dashboard_overview_provider.dart';
import '../../tasks/providers/task_provider.dart';
import '../models/daily_briefing.dart';

final dailyBriefingProvider = Provider<DailyBriefing>((ref) {
  final overview = ref.watch(dashboardOverviewProvider);
  final tasks = ref.watch(taskProvider);

  final hour = DateTime.now().hour;

  final greeting = hour < 12
      ? "Good Morning ☀️"
      : hour < 17
      ? "Good Afternoon 🌤"
      : "Good Evening 🌙";

  final pending = overview.totalTasks - overview.completedTasks;

  String recommendation = "You're doing great today.";

  final pendingTasks = tasks.where((t) => !t.isCompleted).toList();

  if (pendingTasks.isNotEmpty) {
    recommendation =
        'Complete "${pendingTasks.first.title}" first for maximum productivity.';
  }

  return DailyBriefing(
    greeting: greeting,
    summary:
        "You have $pending pending tasks and "
        "${overview.completedHabits}/${overview.totalHabits} habits completed today.",
    recommendation: recommendation,
  );
});
