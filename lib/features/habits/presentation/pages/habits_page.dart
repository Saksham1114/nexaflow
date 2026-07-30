import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/habit_provider.dart';
import '../../providers/habit_statistics_provider.dart';
import '../widgets/habit_card.dart';
import '../widgets/streak_card.dart';

class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);
    final stats = ref.watch(habitStatisticsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Streak Card
          StreakCard(current: stats.currentStreak, best: stats.bestStreak),

          const SizedBox(height: 24),

          // Habit List
          ...habits.map(
            (habit) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HabitCard(
                habit: habit,
                onToggle: () {
                  ref.read(habitProvider.notifier).toggle(habit.id);
                },
              ),
            ),
          ),

          if (habits.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 60),
              child: Center(
                child: Text(
                  "No habits added yet",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
