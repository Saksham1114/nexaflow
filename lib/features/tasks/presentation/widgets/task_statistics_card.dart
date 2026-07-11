import 'package:flutter/material.dart';

class TaskStatisticsCard extends StatelessWidget {
  const TaskStatisticsCard({
    super.key,
    required this.total,
    required this.pending,
    required this.completed,
  });

  final int total;
  final int pending;
  final int completed;

  double get progress {
    if (total == 0) return 0;
    return completed / total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Progress", style: theme.textTheme.titleLarge),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(value: progress, minHeight: 10),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(label: "Total", value: total.toString()),
              _StatItem(label: "Pending", value: pending.toString()),
              _StatItem(label: "Done", value: completed.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(value, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
