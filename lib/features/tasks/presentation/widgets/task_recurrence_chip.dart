import 'package:flutter/material.dart';

import '../../models/task_recurrence.dart';

class TaskRecurrenceChip extends StatelessWidget {
  const TaskRecurrenceChip({super.key, required this.recurrence});

  final TaskRecurrence recurrence;

  @override
  Widget build(BuildContext context) {
    if (recurrence == TaskRecurrence.none) {
      return const SizedBox.shrink();
    }

    return Chip(
      avatar: const Icon(Icons.repeat, size: 16),
      label: Text(recurrence.shortTitle),
    );
  }
}
