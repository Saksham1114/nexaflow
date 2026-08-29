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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'category': category.name,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      category: TaskCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TaskCategory.personal,
      ),
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'] as String)
          : null,
    );
  }
}

