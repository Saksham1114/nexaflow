class DayCompletion {
  const DayCompletion({
    required this.date,
    required this.dayLabel,
    required this.isCompleted,
    required this.isToday,
  });

  final DateTime date;
  final String dayLabel;
  final bool isCompleted;
  final bool isToday;
}

class StreakMilestone {
  const StreakMilestone({
    required this.days,
    required this.title,
    required this.isUnlocked,
    required this.icon,
  });

  final int days;
  final String title;
  final bool isUnlocked;
  final String icon;
}

class StreakInfo {
  const StreakInfo({
    required this.currentStreak,
    required this.bestStreak,
    required this.isTodayCompleted,
    required this.last7Days,
    required this.milestones,
    required this.completedDates,
  });

  final int currentStreak;
  final int bestStreak;
  final bool isTodayCompleted;
  final List<DayCompletion> last7Days;
  final List<StreakMilestone> milestones;
  final Set<String> completedDates;

  static const empty = StreakInfo(
    currentStreak: 0,
    bestStreak: 0,
    isTodayCompleted: false,
    last7Days: [],
    milestones: [],
    completedDates: {},
  );
}
