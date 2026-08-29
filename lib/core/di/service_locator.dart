import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/storage_service.dart';
import '../../features/tasks/data/task_repository_impl.dart';
import '../../features/tasks/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return TaskRepositoryImpl(storage);
});

