import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/streak_provider.dart';
import '../models/habit_statistics.dart';
import 'habit_provider.dart';

final habitStatisticsProvider = Provider<HabitStatistics>((ref) {
  final habits = ref.watch(habitProvider);
  final streak = ref.watch(streakProvider);

  final completed = habits.where((e) => e.completedToday).length;

  return HabitStatistics(
    currentStreak: streak.currentStreak,
    bestStreak: streak.bestStreak,
    completedToday: completed,
    totalHabits: habits.length,
  );
});

