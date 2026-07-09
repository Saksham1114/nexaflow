import 'package:flutter/material.dart';

import 'package:nexaflow/shared/widgets/dashboard_card.dart';

class ProductivityCard extends StatelessWidget {
  const ProductivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Productivity", style: theme.textTheme.titleLarge),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: const LinearProgressIndicator(value: .72, minHeight: 12),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text("72%", style: theme.textTheme.headlineMedium),
              const Spacer(),
              const Icon(Icons.trending_up, color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }
}
