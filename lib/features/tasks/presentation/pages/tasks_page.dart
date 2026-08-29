import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task.dart';
import 'package:nexaflow/features/tasks/providers/task_provider.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter_chip.dart';
import '../widgets/task_search_bar.dart';
import '../widgets/task_statistics_card.dart';
import 'task_details_page.dart';

enum TaskFilter { all, pending, completed }

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  final TextEditingController _searchController = TextEditingController();
  TaskFilter _filter = TaskFilter.all;
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openTask(Task task) async {
    final Task? updatedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => TaskDetailsPage(task: task)),
    );

    if (updatedTask == null) return;
    ref.read(taskProvider.notifier).update(updatedTask);
  }

  List<Task> _getFilteredTasks(List<Task> allTasks) {
    List<Task> result;

    switch (_filter) {
      case TaskFilter.pending:
        result = allTasks.where((task) => !task.isCompleted).toList();
        break;

      case TaskFilter.completed:
        result = allTasks.where((task) => task.isCompleted).toList();
        break;

      case TaskFilter.all:
        result = List.from(allTasks);
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
    ref.read(taskProvider.notifier).add(task);
  }

  void _toggleTask(Task task) {
    ref.read(taskProvider.notifier).toggle(task);
  }

  void _deleteTask(Task task) {
    ref.read(taskProvider.notifier).delete(task.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Task deleted"),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            ref.read(taskProvider.notifier).add(task);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final pendingTasks = tasks.where((task) => !task.isCompleted).length;
    final filteredTasks = _getFilteredTasks(tasks);

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
