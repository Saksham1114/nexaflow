import '../task_repository.dart';

class DeleteTaskUseCase {
  const DeleteTaskUseCase(this.repository);

  final TaskRepository repository;

  Future<void> call(String id) {
    return repository.deleteTask(id);
  }
}
