import 'package:flutter/material.dart';

import '../../../../shared/widgets/dashboard_card.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Quick Actions", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_task),
                label: const Text("Task"),
              ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.water_drop),
                label: const Text("Water"),
              ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle),
                label: const Text("Habit"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
