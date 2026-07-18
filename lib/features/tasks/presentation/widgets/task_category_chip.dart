import 'package:flutter/material.dart';

import '../../models/task_category.dart';

class TaskCategoryChip extends StatelessWidget {
  const TaskCategoryChip({super.key, required this.category});

  final TaskCategory category;

  Color get color {
    switch (category) {
      case TaskCategory.work:
        return Colors.blue;

      case TaskCategory.personal:
        return Colors.purple;

      case TaskCategory.study:
        return Colors.orange;

      case TaskCategory.health:
        return Colors.green;

      case TaskCategory.finance:
        return Colors.teal;

      case TaskCategory.shopping:
        return Colors.pink;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(category.title),
      backgroundColor: color.withValues(alpha: .15),
      side: BorderSide.none,
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
    );
  }
}
