import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter_chip.dart';
import '../widgets/task_search_bar.dart';
import '../widgets/task_statistics_card.dart';
import 'task_details_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/task_category.dart';

enum TaskFilter { all, pending, completed }

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Finish NexaFlow Dashboard',
      description: 'Complete Sprint 2 Task Module',
      priority: TaskPriority.high,
      category: TaskCategory.work,
      isCompleted: false,
      createdAt: DateTime.now(),
    ),
    Task(
      id: '2',
      title: 'Workout',
      description: 'Chest & Triceps',
      priority: TaskPriority.medium,
      category: TaskCategory.health,
      isCompleted: false,
      createdAt: DateTime.now(),
    ),
    Task(
      id: '3',
      title: 'Drink Water',
      description: 'Complete 4L today',
      priority: TaskPriority.low,
      category: TaskCategory.health,
      isCompleted: true,
      createdAt: DateTime.now(),
    ),
  ];
  Future<void> _openTask(Task task) async {
    final Task? updatedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => TaskDetailsPage(task: task)),
    );

    if (updatedTask == null) return;

    final index = _tasks.indexWhere((e) => e.id == updatedTask.id);

    if (index == -1) return;

    setState(() {
      _tasks[index] = updatedTask;
    });
  }

  int get totalTasks => _tasks.length;

  int get completedTasks => _tasks.where((task) => task.isCompleted).length;

  int get pendingTasks => _tasks.where((task) => !task.isCompleted).length;

  final TextEditingController _searchController = TextEditingController();

  TaskFilter _filter = TaskFilter.all;
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Task> get filteredTasks {
    List<Task> result;

    switch (_filter) {
      case TaskFilter.pending:
        result = _tasks.where((task) => !task.isCompleted).toList();
        break;

      case TaskFilter.completed:
        result = _tasks.where((task) => task.isCompleted).toList();
        break;

      case TaskFilter.all:
        result = List.from(_tasks);
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();

      result = result.where((task) {
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

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
      body: Column(
        children: [
          TaskSearchBar(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          TaskStatisticsCard(
            total: totalTasks,
            pending: pendingTasks,
            completed: completedTasks,
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                TaskFilterChip(
                  label: "All",
                  selected: _filter == TaskFilter.all,
                  onTap: () => setState(() => _filter = TaskFilter.all),
                ),
                const SizedBox(width: 12),
                TaskFilterChip(
                  label: "Pending",
                  selected: _filter == TaskFilter.pending,
                  onTap: () => setState(() => _filter = TaskFilter.pending),
                ),
                const SizedBox(width: 12),
                TaskFilterChip(
                  label: "Completed",
                  selected: _filter == TaskFilter.completed,
                  onTap: () => setState(() => _filter = TaskFilter.completed),
                ),
              ],
            ),
          ),

          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(
                    child: Text(
                      "No Tasks Found",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];

                      return TaskCard(
                        task: task,
                        onToggle: () => _toggleTask(task),
                        onDelete: () => _deleteTask(task),
                        onTap: () => _openTask(task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
