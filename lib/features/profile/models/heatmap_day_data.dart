class HeatmapDayData {
  const HeatmapDayData({
    required this.date,
    required this.tasksCompleted,
    required this.habitsCompleted,
    required this.focusMinutes,
    required this.score,
  });

  final DateTime date;
  final int tasksCompleted;
  final int habitsCompleted;
  final int focusMinutes;
  final int score;

  bool get hasActivity => score > 0;
}
