enum HabitFrequency { daily, weekly }

class Habit {
  const Habit({
    required this.id,
    required this.title,
    required this.frequency,
    required this.completedToday,
    required this.createdAt,
  });

  final String id;
  final String title;
  final HabitFrequency frequency;
  final bool completedToday;
  final DateTime createdAt;

  Habit copyWith({
    String? id,
    String? title,
    HabitFrequency? frequency,
    bool? completedToday,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      frequency: frequency ?? this.frequency,
      completedToday: completedToday ?? this.completedToday,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
