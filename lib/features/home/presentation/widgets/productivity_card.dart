import 'package:flutter/material.dart';

class ProductivityCard extends StatelessWidget {
  const ProductivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Productivity", style: theme.textTheme.titleLarge),
          const SizedBox(height: 24),

          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: const LinearProgressIndicator(value: 0.72, minHeight: 12),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Text("72%", style: theme.textTheme.headlineMedium),
              const Spacer(),
              const Icon(Icons.trending_up, color: Colors.green),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            "You're ahead of yesterday 🚀",
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
