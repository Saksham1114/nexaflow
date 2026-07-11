import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/tasks/repositories/in_memory_task_repository.dart';
import '../../features/tasks/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return InMemoryTaskRepository();
});
