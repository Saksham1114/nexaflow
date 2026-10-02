import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/habit.dart';
import '../../providers/habit_provider.dart';
import '../../providers/habit_statistics_provider.dart';
import '../widgets/add_habit_bottom_sheet.dart';
import '../widgets/habit_card.dart';
import '../widgets/streak_card.dart';

class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  void _showAddHabitSheet(BuildContext context, [Habit? habitToEdit]) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => AddHabitBottomSheet(habitToEdit: habitToEdit),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);
    final stats = ref.watch(habitStatisticsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Habits Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddHabitSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Habit'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Streak Card
          StreakCard(current: stats.currentStreak, best: stats.bestStreak),

          const SizedBox(height: 20),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Habits (${habits.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${habits.where((h) => h.completedToday).length} done today',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Habit List
          ...habits.map(
            (habit) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HabitCard(
                habit: habit,
                onToggle: () {
                  ref.read(habitProvider.notifier).toggle(habit.id);
                },
                onDelete: () {
                  ref.read(habitProvider.notifier).delete(habit.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Deleted "${habit.title}"'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          ref.read(habitProvider.notifier).add(habit);
                        },
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onEdit: () => _showAddHabitSheet(context, habit),
              ),
            ),
          ),

          if (habits.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 64,
                    color: theme.colorScheme.primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No habits added yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Build consistency by adding daily or weekly habits.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.tonalIcon(
                    onPressed: () => _showAddHabitSheet(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Create your first habit'),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
