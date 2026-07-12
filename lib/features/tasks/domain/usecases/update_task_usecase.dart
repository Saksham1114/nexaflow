import '../task_repository.dart';
import '../../models/task.dart';

class UpdateTaskUseCase {
  const UpdateTaskUseCase(this.repository);

  final TaskRepository repository;

  Future<void> call(Task task) {
    return repository.updateTask(task);
  }
}
