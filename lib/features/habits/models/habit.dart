enum HabitFrequency { daily, weekly }

class Habit {
  const Habit({
    required this.id,
    required this.title,
    required this.frequency,
    required this.completedToday,
    required this.createdAt,
    this.lastCompletedDate,
    this.iconName = 'star',
    this.colorValue = 0xFF6366F1, // Default Indigo
    this.reminderTime,
  });

  final String id;
  final String title;
  final HabitFrequency frequency;
  final bool completedToday;
  final DateTime createdAt;
  final DateTime? lastCompletedDate;
  final String iconName;
  final int colorValue;
  final String? reminderTime; // e.g. "08:30"

  Habit copyWith({
    String? id,
    String? title,
    HabitFrequency? frequency,
    bool? completedToday,
    DateTime? createdAt,
    DateTime? lastCompletedDate,
    String? iconName,
    int? colorValue,
    String? reminderTime,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      frequency: frequency ?? this.frequency,
      completedToday: completedToday ?? this.completedToday,
      createdAt: createdAt ?? this.createdAt,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'frequency': frequency.name,
      'completedToday': completedToday,
      'createdAt': createdAt.toIso8601String(),
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'iconName': iconName,
      'colorValue': colorValue,
      'reminderTime': reminderTime,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    final lastCompletedStr = json['lastCompletedDate'] as String?;
    final lastCompleted =
        lastCompletedStr != null ? DateTime.tryParse(lastCompletedStr) : null;

    bool isCompletedToday = json['completedToday'] as bool? ?? false;
    if (lastCompleted != null) {
      final now = DateTime.now();
      final isSameDay = lastCompleted.year == now.year &&
          lastCompleted.month == now.month &&
          lastCompleted.day == now.day;
      isCompletedToday = isSameDay;
    }

    return Habit(
      id: json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? '',
      frequency: HabitFrequency.values.firstWhere(
        (e) => e.name == json['frequency'],
        orElse: () => HabitFrequency.daily,
      ),
      completedToday: isCompletedToday,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      lastCompletedDate: lastCompleted,
      iconName: json['iconName'] as String? ?? 'star',
      colorValue: json['colorValue'] as int? ?? 0xFF6366F1,
      reminderTime: json['reminderTime'] as String?,
    );
  }
}
