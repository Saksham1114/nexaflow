import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/habit.dart';

class HabitNotifier extends StateNotifier<List<Habit>> {
  HabitNotifier()
    : super([
        Habit(
          id: '1',
          title: 'Workout',
          frequency: HabitFrequency.daily,
          completedToday: false,
          createdAt: DateTime.now(),
        ),
        Habit(
          id: '2',
          title: 'Read 20 Pages',
          frequency: HabitFrequency.daily,
          completedToday: true,
          createdAt: DateTime.now(),
        ),
      ]);

  void toggle(String id) {
    state = [
      for (final habit in state)
        if (habit.id == id)
          habit.copyWith(completedToday: !habit.completedToday)
        else
          habit,
    ];
  }

  void add(Habit habit) {
    state = [habit, ...state];
  }
}

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>(
  (ref) => HabitNotifier(),
);
