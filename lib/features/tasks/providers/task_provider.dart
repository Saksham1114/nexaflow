import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier()
    : super([
        Task(
          id: '1',
          title: 'Finish NexaFlow Dashboard',
          description: 'Complete Sprint 2 Task Module',
          priority: TaskPriority.high,
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
        Task(
          id: '2',
          title: 'Workout',
          description: 'Chest & Triceps',
          priority: TaskPriority.medium,
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
        Task(
          id: '3',
          title: 'Drink Water',
          description: 'Complete 4L today',
          priority: TaskPriority.low,
          isCompleted: true,
          createdAt: DateTime.now(),
        ),
      ]);

  void add(Task task) {
    state = [task, ...state];
  }

  void delete(String id) {
    state = state.where((task) => task.id != id).toList();
  }

  void update(Task task) {
    state = [
      for (final t in state)
        if (t.id == task.id) task else t,
    ];
  }

  void toggle(String id) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(isCompleted: !t.isCompleted) else t,
    ];
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>(
  (ref) => TaskNotifier(),
);
