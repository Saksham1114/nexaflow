class DashboardOverview {
  const DashboardOverview({
    required this.completedTasks,
    required this.totalTasks,
    required this.completedHabits,
    required this.totalHabits,
    required this.focusMinutes,
    required this.waterConsumed,
    required this.waterGoal,
    required this.productivity,
  });

  final int completedTasks;
  final int totalTasks;

  final int completedHabits;
  final int totalHabits;

  final int focusMinutes;

  final int waterConsumed;
  final int waterGoal;

  final double productivity;

  int get pendingTasks => totalTasks - completedTasks;
  int get totalWater => waterConsumed;
  double get waterLiters => waterConsumed / 1000.0;
  double get taskCompletionRate =>
      totalTasks == 0 ? 1.0 : completedTasks / totalTasks;
  double get habitCompletionRate =>
      totalHabits == 0 ? 1.0 : completedHabits / totalHabits;
  double get waterCompletionRate =>
      waterGoal == 0 ? 1.0 : (waterConsumed / waterGoal).clamp(0.0, 1.0);
}

typedef DashboardStats = DashboardOverview;

