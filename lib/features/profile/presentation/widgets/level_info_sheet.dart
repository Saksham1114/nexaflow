import 'package:flutter/material.dart';

import '../../models/user_profile.dart';

class LevelInfoSheet extends StatelessWidget {
  const LevelInfoSheet({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Level & XP System",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Level ${profile.level}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Earn XP automatically by building habits, completing tasks, staying hydrated, and focusing.",
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 20),
          _XpRow(
            icon: Icons.check_circle_outline,
            title: "Task Completed",
            xp: "+50 XP",
            color: Colors.green,
          ),
          _XpRow(
            icon: Icons.repeat_rounded,
            title: "Daily Habit Check-in",
            xp: "+30 XP",
            color: Colors.amber,
          ),
          _XpRow(
            icon: Icons.timer_outlined,
            title: "Pomodoro Focus Session",
            xp: "+100 XP",
            color: Colors.indigo,
          ),
          _XpRow(
            icon: Icons.water_drop_outlined,
            title: "Hydration (per 250ml)",
            xp: "+10 XP",
            color: Colors.blue,
          ),
          _XpRow(
            icon: Icons.local_fire_department_outlined,
            title: "Daily Streak Maintained",
            xp: "+150 XP / day",
            color: Colors.deepOrange,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Awesome!"),
            ),
          ),
        ],
      ),
    );
  }
}

class _XpRow extends StatelessWidget {
  const _XpRow({
    required this.icon,
    required this.title,
    required this.xp,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String xp;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              xp,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
