import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({super.key, required this.currentStreak});

  final int currentStreak;

  @override
  Widget build(BuildContext context) {
    final days = ["M", "T", "W", "T", "F", "S", "S"];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("🔥", style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Text(
                "$currentStreak Day Streak",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final completed = index < currentStreak.clamp(0, 7);

              return Column(
                children: [
                  Text(days[index]),

                  const SizedBox(height: 8),

                  CircleAvatar(
                    radius: 18,
                    backgroundColor: completed
                        ? Colors.orange
                        : Colors.grey.shade300,
                    child: Icon(
                      completed ? Icons.check : Icons.circle_outlined,
                      color: completed ? Colors.white : Colors.grey,
                      size: 18,
                    ),
                  ),
                ],
              );
            }),
          ),

          const SizedBox(height: 18),

          Text(
            "Keep it going 💪",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
