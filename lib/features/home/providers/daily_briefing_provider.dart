import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/streak_provider.dart';
import '../../ai/models/daily_briefing.dart';
import '../../ai/services/ai_assistant_service.dart';
import '../../focus/providers/focus_provider.dart';
import '../../habits/providers/habit_provider.dart';
import '../../settings/providers/settings_provider.dart';
import '../../tasks/providers/task_provider.dart';
import '../../water/providers/water_provider.dart';

export '../../ai/models/daily_briefing.dart';

final dailyBriefingProvider = Provider<DailyBriefing>((ref) {
  final tasks = ref.watch(taskProvider);
  final habits = ref.watch(habitProvider);
  final waterEntries = ref.watch(waterProvider);
  final settings = ref.watch(settingsProvider);
  final streak = ref.watch(streakProvider);
  final focus = ref.watch(focusProvider);
  final aiService = ref.watch(aiAssistantServiceProvider);

  return aiService.generateDailyBriefing(
    tasks: tasks,
    habits: habits,
    waterEntries: waterEntries,
    waterGoal: settings.dailyGoal,
    currentStreak: streak.currentStreak,
    focusMinutes: focus.completedSessions * focus.duration.inMinutes,
  );
});

