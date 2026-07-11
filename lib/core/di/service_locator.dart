import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/tasks/data/task_repository_impl.dart';
import '../../features/tasks/domain/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl();
});
