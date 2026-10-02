import 'package:flutter/material.dart';

import '../../models/habit.dart';
import '../../utils/habit_icon_helper.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final habitColor = HabitIconHelper.getColor(habit.colorValue);
    final habitIcon = HabitIconHelper.getIcon(habit.iconName);

    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Habit'),
                content: Text(
                  'Are you sure you want to delete "${habit.title}"?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) => onDelete(),
      child: Material(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: habit.completedToday ? 0.5 : 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: habit.completedToday
                    ? habitColor.withValues(alpha: 0.4)
                    : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06)),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Habit Icon Container
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: habit.completedToday
                        ? habitColor
                        : habitColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    habitIcon,
                    color: habit.completedToday ? Colors.white : habitColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),

                // Title and Metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: habit.completedToday
                              ? TextDecoration.lineThrough
                              : null,
                          color: habit.completedToday
                              ? (isDark ? Colors.white54 : Colors.black45)
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: habitColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              habit.frequency.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: habitColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          if (habit.reminderTime != null) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.alarm_rounded,
                              size: 13,
                              color: isDark ? Colors.white60 : Colors.black45,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              habit.reminderTime!,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.white60 : Colors.black45,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Edit Button
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  color: isDark ? Colors.white38 : Colors.black38,
                  onPressed: onEdit,
                ),

                // Completion Toggle Checkbox
                Transform.scale(
                  scale: 1.15,
                  child: Checkbox(
                    value: habit.completedToday,
                    activeColor: habitColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onChanged: (_) => onToggle(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
