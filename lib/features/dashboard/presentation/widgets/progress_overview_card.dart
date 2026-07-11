import 'package:flutter/material.dart';

import '../../../../shared/widgets/dashboard_card.dart';

class ProgressOverviewCard extends StatelessWidget {
  const ProgressOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Progress",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: const LinearProgressIndicator(value: .68, minHeight: 10),
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tasks 7/10"),
              Text("Water 2.5L"),
              Text("Habits 5/6"),
            ],
          ),
        ],
      ),
    );
  }
}
