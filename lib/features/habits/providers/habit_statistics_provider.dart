import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'habit_provider.dart';
import '../models/habit_statistics.dart';

final habitStatisticsProvider = Provider<HabitStatistics>((ref) {
  final habits = ref.watch(habitProvider);

  final completed = habits.where((e) => e.completedToday).length;

  return HabitStatistics(
    currentStreak: 7,
    bestStreak: 15,
    completedToday: completed,
    totalHabits: habits.length,
  );
});
