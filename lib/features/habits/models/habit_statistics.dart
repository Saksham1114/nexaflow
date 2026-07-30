class HabitStatistics {
  const HabitStatistics({
    required this.currentStreak,
    required this.bestStreak,
    required this.completedToday,
    required this.totalHabits,
  });

  final int currentStreak;
  final int bestStreak;
  final int completedToday;
  final int totalHabits;

  double get completionRate {
    if (totalHabits == 0) return 0;
    return completedToday / totalHabits;
  }

  bool get perfectDay => totalHabits > 0 && completedToday == totalHabits;
}
