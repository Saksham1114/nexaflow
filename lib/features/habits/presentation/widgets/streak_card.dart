import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.current,
    required this.best,
  });

  final int current;
  final int best;

  String _getMilestoneBadge(int streak) {
    if (streak >= 100) return "👑 Centurion";
    if (streak >= 60) return "💎 Titan";
    if (streak >= 30) return "🏆 Master";
    if (streak >= 7) return "⚡ Warrior";
    return "🌱 Starter";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.cardColor,
        border: Border.all(
          color: current > 0 ? Colors.orange.withAlpha(50) : theme.dividerColor.withAlpha(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: current > 0
                  ? Colors.orange.withAlpha(30)
                  : theme.colorScheme.surfaceContainerHighest,
            ),
            child: Center(
              child: Text(
                current > 0 ? "🔥" : "⏳",
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "$current Day Streak",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _getMilestoneBadge(current),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Personal Best: $best days",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
