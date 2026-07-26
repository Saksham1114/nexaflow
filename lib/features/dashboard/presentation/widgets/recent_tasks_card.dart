import 'package:flutter/material.dart';

import '../../../tasks/models/task.dart';

class RecentTasksCard extends StatelessWidget {
  const RecentTasksCard({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              "No tasks available",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Recent Tasks", style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 18),

            ...tasks
                .take(5)
                .map(
                  (task) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.isCompleted ? Colors.green : Colors.grey,
                    ),
                    title: Text(task.title),
                    subtitle: Text(
                      task.description.isEmpty
                          ? "No description"
                          : task.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: task.hasDueDate
                        ? Text("${task.dueDate!.day}/${task.dueDate!.month}")
                        : null,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
