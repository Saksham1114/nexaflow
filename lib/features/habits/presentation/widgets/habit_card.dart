import 'package:flutter/material.dart';

import '../../models/habit.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({super.key, required this.habit, required this.onToggle});

  final Habit habit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        value: habit.completedToday,
        onChanged: (_) => onToggle(),
        title: Text(habit.title),
        subtitle: Text(habit.frequency.name.toUpperCase()),
      ),
    );
  }
}
