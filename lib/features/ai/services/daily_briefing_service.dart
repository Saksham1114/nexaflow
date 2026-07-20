import '../models/daily_briefing.dart';

class DailyBriefingService {
  const DailyBriefingService();

  DailyBriefing generate({
    required int pendingTasks,
    required int completedTasks,
    required int water,
    required int habitsCompleted,
  }) {
    final greeting = switch (DateTime.now().hour) {
      < 12 => "Good Morning",
      < 17 => "Good Afternoon",
      _ => "Good Evening",
    };

    return DailyBriefing(
      greeting: greeting,
      summary:
          "You have $pendingTasks pending tasks, completed $completedTasks tasks, drank $water ml of water and completed $habitsCompleted habits today.",
      recommendation: pendingTasks > 0
          ? "Complete your highest priority task first."
          : "Excellent work! Maintain your momentum.",
    );
  }
}
