import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/habits/providers/habit_provider.dart';
import '../../features/tasks/providers/task_provider.dart';
import '../models/streak_model.dart';
import '../services/storage_service.dart';
import '../services/streak_service.dart';

final streakServiceProvider = Provider<StreakService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return StreakService(storage);
});

class StreakNotifier extends StateNotifier<StreakInfo> {
  StreakNotifier(this._service) : super(StreakInfo.empty) {
    _init();
  }

  final StreakService _service;
  Set<String> _completedDates = {};

  void _init() {
    _completedDates = _service.loadCompletedDates();
    state = _service.calculateStreakInfo(_completedDates);
  }

  void checkAndUpdateFromActivity({
    required int completedTasksToday,
    required int completedHabitsToday,
  }) {
    final now = DateTime.now();
    final todayStr = _service.formatDate(now);

    final hasActivityToday = completedTasksToday > 0 || completedHabitsToday > 0;

    if (hasActivityToday && !_completedDates.contains(todayStr)) {
      _completedDates.add(todayStr);
      _service.saveCompletedDates(_completedDates);
      state = _service.calculateStreakInfo(_completedDates);
    } else if (!hasActivityToday && _completedDates.contains(todayStr)) {
      // If user unchecked everything, revert today's completion
      _completedDates.remove(todayStr);
      _service.saveCompletedDates(_completedDates);
      state = _service.calculateStreakInfo(_completedDates);
    }
  }

  Future<void> recordDate(DateTime date) async {
    final dateStr = _service.formatDate(date);
    _completedDates.add(dateStr);
    await _service.saveCompletedDates(_completedDates);
    state = _service.calculateStreakInfo(_completedDates);
  }
}

final streakNotifierProvider =
    StateNotifierProvider<StreakNotifier, StreakInfo>((ref) {
  final service = ref.watch(streakServiceProvider);
  return StreakNotifier(service);
});

final streakProvider = Provider<StreakInfo>((ref) {
  final notifier = ref.watch(streakNotifierProvider.notifier);
  final streakInfo = ref.watch(streakNotifierProvider);

  final tasks = ref.watch(taskProvider);
  final habits = ref.watch(habitProvider);

  final completedTasks = tasks.where((t) => t.isCompleted).length;
  final completedHabits = habits.where((h) => h.completedToday).length;

  // Reactively synchronize streak with user task and habit completions
  notifier.checkAndUpdateFromActivity(
    completedTasksToday: completedTasks,
    completedHabitsToday: completedHabits,
  );

  return streakInfo;
});
