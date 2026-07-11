import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../../../core/di/service_locator.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier(this._repository) : super([]);

  final TaskRepository _repository;

  Future<void> loadTasks() async {
    state = await _repository.getTasks();
  }

  Future<void> add(Task task) async {
    await _repository.addTask(task);
    await loadTasks();
  }

  Future<void> update(Task task) async {
    await _repository.updateTask(task);
    await loadTasks();
  }

  Future<void> delete(String id) async {
    await _repository.deleteTask(id);
    await loadTasks();
  }

  Future<void> toggle(Task task) async {
    await update(task.copyWith(isCompleted: !task.isCompleted));
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);

  final notifier = TaskNotifier(repository);

  notifier.loadTasks();

  return notifier;
});
