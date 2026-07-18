import 'package:flutter/material.dart';

class TaskEmptyState extends StatelessWidget {
  const TaskEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 72, color: Colors.grey.shade500),
          const SizedBox(height: 16),
          Text("No Tasks Yet", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            "Tap the + button to create your first task.",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
