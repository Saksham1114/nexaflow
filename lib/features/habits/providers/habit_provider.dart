import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/storage_service.dart';
import '../data/habit_repository_impl.dart';
import '../models/habit.dart';
import '../repositories/habit_repository.dart';

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return HabitRepositoryImpl(storage);
});

class HabitNotifier extends StateNotifier<List<Habit>> {
  HabitNotifier(this._repository) : super([]) {
    loadHabits();
  }

  final HabitRepository _repository;

  Future<void> loadHabits() async {
    state = await _repository.getHabits();
  }

  Future<void> toggle(String id) async {
    await _repository.toggleHabit(id);
    await loadHabits();
  }

  Future<void> add(Habit habit) async {
    await _repository.addHabit(habit);
    await loadHabits();
  }

  Future<void> delete(String id) async {
    await _repository.deleteHabit(id);
    await loadHabits();
  }

  Future<void> update(Habit habit) async {
    await _repository.updateHabit(habit);
    await loadHabits();
  }
}

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return HabitNotifier(repository);
});

