import 'package:flutter/material.dart';

class ProductivityCard extends StatelessWidget {
  const ProductivityCard({super.key, this.productivity = 0.0});

  final double productivity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = productivity.clamp(0.0, 1.0);
    final percentage = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Productivity", style: theme.textTheme.titleLarge),
          const SizedBox(height: 24),

          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Text("$percentage%", style: theme.textTheme.headlineMedium),
              const Spacer(),
              Icon(
                percentage >= 50 ? Icons.trending_up : Icons.trending_flat,
                color: percentage >= 50 ? Colors.green : Colors.amber,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            percentage >= 80
                ? "Outstanding progress today! 🚀"
                : percentage >= 50
                ? "You're making solid progress 💪"
                : "Keep going, every step counts! ✨",
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

