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
  final service = ref.watch(streakServiceProvider);
  final completedDates = service.loadCompletedDates();

  final tasks = ref.watch(taskProvider);
  final habits = ref.watch(habitProvider);

  final completedTasks = tasks.where((t) => t.isCompleted).length;
  final completedHabits = habits.where((h) => h.completedToday).length;
  final hasActivityToday = completedTasks > 0 || completedHabits > 0;

  final todayStr = service.formatDate(DateTime.now());
  final updatedDates = Set<String>.from(completedDates);

  if (hasActivityToday) {
    if (!updatedDates.contains(todayStr)) {
      updatedDates.add(todayStr);
      Future.microtask(() => service.saveCompletedDates(updatedDates));
    }
  } else {
    if (updatedDates.contains(todayStr)) {
      updatedDates.remove(todayStr);
      Future.microtask(() => service.saveCompletedDates(updatedDates));
    }
  }

  return service.calculateStreakInfo(updatedDates);
});

