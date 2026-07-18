import 'task_category.dart';

enum TaskPriority { low, medium, high }

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    required this.isCompleted,
    required this.createdAt,
    this.dueDate,
  });

  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskCategory category;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;

  bool get hasDueDate => dueDate != null;

  bool get isOverdue {
    if (dueDate == null) return false;

    return !isCompleted && dueDate!.isBefore(DateTime.now());
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskCategory? category,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
