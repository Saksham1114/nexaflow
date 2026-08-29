import 'package:flutter/material.dart';

import '../../../../core/models/streak_model.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.streak,
  });

  final StreakInfo streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = streak.last7Days;

    final motivationalText = streak.isTodayCompleted
        ? "Today's goal completed! Streak secured 🔥"
        : streak.currentStreak > 0
        ? "Complete a task or habit to keep your ${streak.currentStreak}-day streak alive 💪"
        : "Complete your first task or habit to start a streak! 🚀";

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("🔥", style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${streak.currentStreak} Day Streak",
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Personal Best: ${streak.bestStreak} days",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (streak.isTodayCompleted)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withAlpha(120)),
                  ),
                  child: const Text(
                    "Active",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((day) {
              return Column(
                children: [
                  Text(
                    day.dayLabel,
                    style: TextStyle(
                      fontWeight:
                          day.isToday ? FontWeight.bold : FontWeight.normal,
                      color: day.isToday
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: day.isCompleted
                          ? Colors.orange
                          : day.isToday
                          ? Colors.orange.withAlpha(30)
                          : theme.colorScheme.surfaceContainerHighest,
                      border: day.isToday
                          ? Border.all(
                              color: Colors.orange,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Icon(
                      day.isCompleted
                          ? Icons.local_fire_department
                          : day.isToday
                          ? Icons.hourglass_top_rounded
                          : Icons.circle_outlined,
                      color: day.isCompleted
                          ? Colors.white
                          : day.isToday
                          ? Colors.orange
                          : theme.colorScheme.outlineVariant,
                      size: 18,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          Text(
            motivationalText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

