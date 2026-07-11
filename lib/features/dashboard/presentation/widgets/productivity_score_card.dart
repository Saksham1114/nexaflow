import 'package:flutter/material.dart';

import '../../../../shared/widgets/dashboard_card.dart';

class ProductivityScoreCard extends StatelessWidget {
  const ProductivityScoreCard({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final percent = (progress * 100).round();

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Productivity", style: theme.textTheme.titleLarge),

          const SizedBox(height: 20),

          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LinearProgressIndicator(value: progress, minHeight: 12),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Text("$percent%", style: theme.textTheme.headlineMedium),
              const Spacer(),
              const Icon(Icons.trending_up, color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }
}
