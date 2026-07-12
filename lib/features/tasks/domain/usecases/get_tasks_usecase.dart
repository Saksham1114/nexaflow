import '../task_repository.dart';
import '../../models/task.dart';

class GetTasksUseCase {
  const GetTasksUseCase(this.repository);

  final TaskRepository repository;

  Future<List<Task>> call() {
    return repository.getTasks();
  }
}
