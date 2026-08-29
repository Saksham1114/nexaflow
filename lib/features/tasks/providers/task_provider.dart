import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/service_locator.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../services/task_notification_service.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier(this._repository, this._notificationService) : super([]);

  final TaskRepository _repository;
  final TaskNotificationService _notificationService;

  Future<void> loadTasks() async {
    state = await _repository.getTasks();
  }

  Future<void> add(Task task) async {
    await _repository.addTask(task);
    await _notificationService.taskCreated(task);
    await loadTasks();
  }

  Future<void> update(Task task) async {
    await _repository.updateTask(task);
    if (task.isCompleted) {
      await _notificationService.taskCompleted(task);
    } else if (task.dueDate != null) {
      await _notificationService.scheduleTaskReminder(task);
    }
    await loadTasks();
  }

  Future<void> delete(String id) async {
    await _notificationService.cancelTaskReminder(id);
    await _repository.deleteTask(id);
    await loadTasks();
  }

  Future<void> toggle(Task task) async {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await update(updated);
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  final notificationService = ref.watch(taskNotificationServiceProvider);

  final notifier = TaskNotifier(repository, notificationService);
  notifier.loadTasks();

  return notifier;
});

