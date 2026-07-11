import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);

  void add(Task task) {
    state = [task, ...state];
  }

  void delete(String id) {
    state = state.where((e) => e.id != id).toList();
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
