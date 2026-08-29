import '../../../core/services/storage_service.dart';
import '../models/habit.dart';
import '../repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  HabitRepositoryImpl(this._storage) {
    _loadFromStorage();
  }

  final StorageService _storage;
  static const String _storageKey = 'nexaflow_habits_data';

  List<Habit> _habits = [];

  void _loadFromStorage() {
    final rawList = _storage.getJsonList(_storageKey);
    if (rawList != null && rawList.isNotEmpty) {
      _habits = rawList.map((e) => Habit.fromJson(e)).toList();
    } else {
      _habits = [
        Habit(
          id: '1',
          title: 'Workout',
          frequency: HabitFrequency.daily,
          completedToday: false,
          createdAt: DateTime.now(),
        ),
        Habit(
          id: '2',
          title: 'Read 20 Pages',
          frequency: HabitFrequency.daily,
          completedToday: true,
          createdAt: DateTime.now(),
          lastCompletedDate: DateTime.now(),
        ),
      ];
      _saveToStorage();
    }
  }

  Future<void> _saveToStorage() async {
    await _storage.setJsonList(
      _storageKey,
      _habits.map((e) => e.toJson()).toList(),
    );
  }

  @override
  Future<List<Habit>> getHabits() async {
    return List.unmodifiable(_habits);
  }

  @override
  Future<void> addHabit(Habit habit) async {
    _habits.insert(0, habit);
    await _saveToStorage();
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((e) => e.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      await _saveToStorage();
    }
  }

  @override
  Future<void> deleteHabit(String id) async {
    _habits.removeWhere((e) => e.id == id);
    await _saveToStorage();
  }

  @override
  Future<void> toggleHabit(String id) async {
    final index = _habits.indexWhere((e) => e.id == id);
    if (index != -1) {
      final current = _habits[index];
      final willBeCompleted = !current.completedToday;
      _habits[index] = current.copyWith(
        completedToday: willBeCompleted,
        lastCompletedDate: willBeCompleted ? DateTime.now() : null,
      );
      await _saveToStorage();
    }
  }
}
