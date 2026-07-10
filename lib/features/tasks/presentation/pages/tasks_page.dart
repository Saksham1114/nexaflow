import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/task_card.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<Task> _tasks = [
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

  Future<void> _addTask() async {
    final Task? task = await showModalBottomSheet<Task>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) => const AddTaskBottomSheet(),
    );

    if (task == null) return;

    setState(() {
      _tasks.insert(0, task);
    });
  }

  void _toggleTask(Task task) {
    final index = _tasks.indexWhere((e) => e.id == task.id);

    if (index == -1) return;

    setState(() {
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
    });
  }

  void _deleteTask(Task task) {
    final index = _tasks.indexWhere((e) => e.id == task.id);

    if (index == -1) return;

    setState(() {
      _tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Task deleted"),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            setState(() {
              _tasks.insert(index, task);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tasks")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        icon: const Icon(Icons.add),
        label: const Text("Task"),
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                "No Tasks Yet",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];

                return TaskCard(
                  task: task,
                  onToggle: () => _toggleTask(task),
                  onDelete: () => _deleteTask(task),
                );
              },
            ),
    );
  }
}
