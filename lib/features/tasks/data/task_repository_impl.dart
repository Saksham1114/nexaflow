import '../../../core/services/storage_service.dart';
import '../models/task.dart';
import '../models/task_category.dart';
import '../repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._storage) {
    _loadFromStorage();
  }

  final StorageService _storage;
  static const String _storageKey = 'nexaflow_tasks_data';

  List<Task> _tasks = [];

  void _loadFromStorage() {
    final rawList = _storage.getJsonList(_storageKey);
    if (rawList != null && rawList.isNotEmpty) {
      _tasks = rawList.map((e) => Task.fromJson(e)).toList();
    } else {
      _tasks = [
        Task(
          id: '1',
          title: 'Finish NexaFlow Dashboard',
          description: 'Complete Sprint 2 Task Module',
          priority: TaskPriority.high,
          category: TaskCategory.work,
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
        Task(
          id: '2',
          title: 'Workout',
          description: 'Chest & Triceps',
          priority: TaskPriority.medium,
          category: TaskCategory.health,
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
        Task(
          id: '3',
          title: 'Drink Water',
          description: 'Complete daily hydration',
          priority: TaskPriority.low,
          category: TaskCategory.health,
          isCompleted: true,
          createdAt: DateTime.now(),
        ),
      ];
      _saveToStorage();
    }
  }

  Future<void> _saveToStorage() async {
    await _storage.setJsonList(
      _storageKey,
      _tasks.map((e) => e.toJson()).toList(),
    );
  }

  @override
  Future<List<Task>> getTasks() async {
    return List.unmodifiable(_tasks);
  }

  @override
  Future<void> addTask(Task task) async {
    _tasks.insert(0, task);
    await _saveToStorage();
  }

  @override
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((e) => e.id == task.id);

    if (index != -1) {
      _tasks[index] = task;
      await _saveToStorage();
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((e) => e.id == id);
    await _saveToStorage();
  }
}

