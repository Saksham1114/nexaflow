import 'package:flutter/material.dart';

import '../../models/task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});

  final Task task;

  Color get priorityColor {
    switch (task.priority) {
      case TaskPriority.high:
        return Colors.red;

      case TaskPriority.medium:
        return Colors.orange;

      case TaskPriority.low:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff1F2937),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Checkbox(value: task.isCompleted, onChanged: (_) {}),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: theme.textTheme.titleMedium),

                const SizedBox(height: 4),

                Text(task.description, style: theme.textTheme.bodyMedium),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    task.priority.name.toUpperCase(),
                    style: TextStyle(
                      color: priorityColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
