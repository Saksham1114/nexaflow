import '../task_repository.dart';
import '../../models/task.dart';

class AddTaskUseCase {
  const AddTaskUseCase(this.repository);

  final TaskRepository repository;

  Future<void> call(Task task) {
    return repository.addTask(task);
  }
}
