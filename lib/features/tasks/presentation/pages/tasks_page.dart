import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../widgets/task_card.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      Task(
        id: '1',
        title: 'Finish NexaFlow Dashboard',
        description: 'Complete Sprint 2 Task Module',
        priority: TaskPriority.high,
        isCompleted: false,
        createdAt: DateTime.now(),
      ),
      Task(
        id: '2',
        title: 'Workout',
        description: 'Chest & Triceps',
        priority: TaskPriority.medium,
        isCompleted: false,
        createdAt: DateTime.now(),
      ),
      Task(
        id: '3',
        title: 'Drink Water',
        description: 'Complete 4L today',
        priority: TaskPriority.low,
        isCompleted: true,
        createdAt: DateTime.now(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Tasks")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("Task"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: tasks.length,
        itemBuilder: (_, index) {
          return TaskCard(task: tasks[index]);
        },
      ),
    );
  }
}
