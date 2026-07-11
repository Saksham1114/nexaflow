import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/habit_provider.dart';
import '../widgets/habit_card.dart';

class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habit = habits[index];

          return HabitCard(
            habit: habit,
            onToggle: () {
              ref.read(habitProvider.notifier).toggle(habit.id);
            },
          );
        },
      ),
    );
  }
}
