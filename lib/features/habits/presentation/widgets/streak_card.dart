import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({super.key, required this.current, required this.best});

  final int current;
  final int best;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 26,
              child: Icon(Icons.local_fire_department),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$current Day Streak 🔥",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Best: $best days",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
