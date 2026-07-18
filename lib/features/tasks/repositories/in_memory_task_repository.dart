import '../models/task.dart';
import '../models/task_category.dart';
import 'task_repository.dart';

class InMemoryTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
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
      description: 'Complete 4L today',
      priority: TaskPriority.low,
      category: TaskCategory.health,
      isCompleted: true,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<Task>> getTasks() async {
    return List.unmodifiable(_tasks);
  }

  @override
  Future<void> addTask(Task task) async {
    _tasks.insert(0, task);
  }

  @override
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((e) => e.id == task.id);

    if (index != -1) {
      _tasks[index] = task;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((e) => e.id == id);
  }
}
