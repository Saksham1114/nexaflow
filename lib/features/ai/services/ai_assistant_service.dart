import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dashboard/models/dashboard_overview.dart';
import '../../habits/models/habit.dart';
import '../../tasks/models/task.dart';
import '../../tasks/models/task_category.dart';
import '../../water/models/water_entry.dart';
import '../models/daily_briefing.dart';

class AIAssistantService {
  const AIAssistantService();

  DailyBriefing generateDailyBriefing({
    required List<Task> tasks,
    required List<Habit> habits,
    required List<WaterEntry> waterEntries,
    required int waterGoal,
    required int currentStreak,
    required int focusMinutes,
  }) {
    final now = DateTime.now();
    final hour = now.hour;

    final greeting = switch (hour) {
      >= 5 && < 12 => "Good morning ☀️",
      >= 12 && < 17 => "Good afternoon 🌤",
      >= 17 && < 22 => "Good evening 🌙",
      _ => "Night owl mode 🦉",
    };

    final pendingTasks = tasks.where((t) => !t.isCompleted).toList();
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final overdueTasks = pendingTasks.where((t) => t.isOverdue).toList();
    final highPriorityTasks =
        pendingTasks.where((t) => t.priority == TaskPriority.high).toList();

    final completedHabits = habits.where((h) => h.completedToday).length;
    final totalHabits = habits.length;

    final totalWater = waterEntries.fold<int>(0, (sum, e) => sum + e.amount);
    final waterPercent = waterGoal > 0
        ? ((totalWater / waterGoal) * 100).clamp(0, 100).toInt()
        : 0;

    // Build intelligent summary
    String summary;
    if (overdueTasks.isNotEmpty) {
      summary =
          "Attention needed: You have ${overdueTasks.length} overdue task(s) and ${pendingTasks.length} total pending tasks.";
    } else if (pendingTasks.isEmpty && totalHabits > 0 && completedHabits == totalHabits) {
      summary =
          "All caught up! You've completed all tasks and habits today with a $currentStreak-day streak.";
    } else {
      summary =
          "You have ${pendingTasks.length} pending task(s), $completedHabits/$totalHabits habits completed, and hydration is at $waterPercent%.";
    }

    // Build intelligent recommendation
    String recommendation;
    String? priorityTaskTitle;

    if (overdueTasks.isNotEmpty) {
      priorityTaskTitle = overdueTasks.first.title;
      recommendation =
          'Resolve overdue task "${overdueTasks.first.title}" first to clear your backlog.';
    } else if (highPriorityTasks.isNotEmpty) {
      priorityTaskTitle = highPriorityTasks.first.title;
      recommendation =
          'Focus on your high-priority task "${highPriorityTasks.first.title}" during your next deep work session.';
    } else if (pendingTasks.isNotEmpty) {
      priorityTaskTitle = pendingTasks.first.title;
      recommendation =
          'Tackle "${pendingTasks.first.title}" to build early momentum.';
    } else if (totalWater < waterGoal) {
      recommendation =
          "You're on top of your tasks! Drink ${waterGoal - totalWater}ml more water to hit your hydration goal.";
    } else {
      recommendation = "You're having a high-impact day! Keep up the momentum.";
    }

    return DailyBriefing(
      greeting: greeting,
      summary: summary,
      recommendation: recommendation,
      priorityTaskTitle: priorityTaskTitle,
      productivityScore: tasks.isEmpty
          ? 1.0
          : (completedTasks / tasks.length),
    );
  }

  String answerUserQuery({
    required String prompt,
    required List<Task> tasks,
    required List<Habit> habits,
    required List<WaterEntry> waterEntries,
    required int waterGoal,
    required int currentStreak,
    required int bestStreak,
    required int focusMinutes,
    required DashboardOverview overview,
  }) {
    final clean = prompt.toLowerCase().trim();

    final pendingTasks = tasks.where((t) => !t.isCompleted).toList();
    final highPriority =
        pendingTasks.where((t) => t.priority == TaskPriority.high).toList();
    final overdue = pendingTasks.where((t) => t.isOverdue).toList();

    final completedHabits = habits.where((h) => h.completedToday).length;
    final totalWater = waterEntries.fold<int>(0, (sum, e) => sum + e.amount);

    // 1. Plan Day / Schedule
    if (clean.contains('plan') ||
        clean.contains('schedule') ||
        clean.contains('what should i do') ||
        clean.contains('start my day') ||
        clean.contains('today')) {
      final buffer = StringBuffer();
      buffer.writeln("📋 **Here is your recommended action plan for today:**\n");

      int step = 1;
      if (overdue.isNotEmpty) {
        buffer.writeln("$step. 🚨 **Urgent:** Clear overdue task `${overdue.first.title}`.");
        step++;
      }

      if (highPriority.isNotEmpty) {
        buffer.writeln("$step. 🎯 **Deep Focus:** Complete high-priority task `${highPriority.first.title}` using a 25-min Pomodoro timer.");
        step++;
      } else if (pendingTasks.isNotEmpty) {
        buffer.writeln("$step. ⚡ **Quick Win:** Finish `${pendingTasks.first.title}`.");
        step++;
      }

      final remainingHabits = habits.where((h) => !h.completedToday).toList();
      if (remainingHabits.isNotEmpty) {
        buffer.writeln("$step. 🔄 **Habit Stack:** Check off `${remainingHabits.first.title}` to protect your $currentStreak-day streak.");
        step++;
      }

      if (totalWater < waterGoal) {
        buffer.writeln("$step. 💧 **Hydration:** Drink a glass of water now (${totalWater}ml / ${waterGoal}ml achieved).");
      }

      buffer.writeln("\n💡 *Tip: Work in 25-minute Pomodoro intervals for peak cognitive performance.*");
      return buffer.toString();
    }

    // 2. Top Priority
    if (clean.contains('priority') ||
        clean.contains('top task') ||
        clean.contains('important') ||
        clean.contains('next')) {
      if (overdue.isNotEmpty) {
        return "🚨 **Highest Priority (Overdue):** `${overdue.first.title}`\n\nThis task is past its due date. We recommend clearing this immediately before moving to new tasks.";
      }
      if (highPriority.isNotEmpty) {
        return "🎯 **Top Priority Task:** `${highPriority.first.title}`\nCategory: ${highPriority.first.category.title}\n\nAllocate 25 minutes of uninterrupted focus to get this done.";
      }
      if (pendingTasks.isNotEmpty) {
        return "⚡ **Next Task:** `${pendingTasks.first.title}`\n\nFinishing this will bring your task completion rate to ${(((tasks.length - pendingTasks.length + 1) / tasks.length) * 100).toInt()}%.";
      }
      return "🎉 **All tasks completed!** You have no pending tasks. Take a well-deserved break or review your habits.";
    }

    // 3. Hydration Check
    if (clean.contains('water') ||
        clean.contains('drink') ||
        clean.contains('hydrate') ||
        clean.contains('hydration')) {
      final remaining = waterGoal - totalWater;
      final percent = waterGoal > 0 ? ((totalWater / waterGoal) * 100).toInt() : 100;

      if (remaining <= 0) {
        return "🌊 **Goal Achieved!** You've reached $totalWater ml today (100% of your $waterGoal ml goal). Superb hydration!";
      } else {
        return "💧 **Hydration Status:**\n- Consumed: **$totalWater ml**\n- Daily Goal: **$waterGoal ml** ($percent%)\n- Remaining: **$remaining ml**\n\nDrink a glass of water now to maintain optimal focus and energy levels.";
      }
    }

    // 4. Streak Status
    if (clean.contains('streak') || clean.contains('consistency') || clean.contains('flame')) {
      return "🔥 **Streak Analytics:**\n- Current Streak: **$currentStreak days**\n- All-time Best: **$bestStreak days**\n- Status Today: **${overview.completedHabits > 0 || overview.completedTasks > 0 ? 'Secured ✅' : 'Pending ⏳'}**\n\nComplete at least 1 task or habit today to keep your streak burning!";
    }

    // 5. Productivity Analysis
    if (clean.contains('productivity') ||
        clean.contains('analysis') ||
        clean.contains('score') ||
        clean.contains('stats') ||
        clean.contains('report')) {
      final scorePercent = (overview.productivity * 100).toInt();
      return "📊 **Productivity Breakdown:**\n"
          "- Overall Score: **$scorePercent%**\n"
          "- Tasks: **${overview.completedTasks}/${overview.totalTasks} completed**\n"
          "- Habits: **${overview.completedHabits}/${overview.totalHabits} completed**\n"
          "- Deep Focus: **$focusMinutes mins**\n"
          "- Hydration: **$totalWater/$waterGoal ml**\n\n"
          "${scorePercent >= 80 ? '🌟 Exceptional productivity today!' : scorePercent >= 50 ? '👍 Solid progress! Push through the remaining goals.' : '🚀 Great time to start a focus session and boost your score!'}";
    }

    // 6. Habit Coaching
    if (clean.contains('habit') || clean.contains('routine')) {
      final remainingHabits = habits.where((h) => !h.completedToday).toList();
      final remainingListStr = remainingHabits.isNotEmpty
          ? "- Remaining: ${remainingHabits.map((h) => '`${h.title}`').join(', ')}\n"
          : "";
      return "⚡ **Habit Coaching & Stacking:**\n"
          "- Completed today: **$completedHabits/${habits.length}**\n"
          "$remainingListStr\n"
          "💡 *Golden Rule of Habits:* Anchor new habits to existing daily triggers (e.g. 'After I brew coffee, I will read 20 pages').";
    }

    // 7. Motivation
    if (clean.contains('motivate') || clean.contains('tired') || clean.contains('lazy') || clean.contains('inspire')) {
      return "💪 *\"Small daily disciplines repeated consistently lead to monumental results.\"*\n\n"
          "You've already built a **$currentStreak-day streak**. You don't need to finish everything at once—just do the next small action for 2 minutes.";
    }

    // 8. General fallback advice
    return "🤖 **NexaFlow AI Copilot**\n\n"
        "I'm analyzing your productivity OS. Currently you have **${pendingTasks.length} pending tasks**, **$completedHabits habits completed**, and **$currentStreak days on your streak**.\n\n"
        "Ask me anything like:\n"
        "- *\"Plan my day\"*\n"
        "- *\"What's my top priority?\"*\n"
        "- *\"Hydration check\"*\n"
        "- *\"Productivity score\"*";
  }
}

final aiAssistantServiceProvider = Provider<AIAssistantService>((ref) {
  return const AIAssistantService();
});
