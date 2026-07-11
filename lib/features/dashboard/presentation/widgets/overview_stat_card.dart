import 'package:flutter/material.dart';

import '../../../../shared/widgets/dashboard_card.dart';

class OverviewStatCard extends StatelessWidget {
  const OverviewStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconColor.withValues(alpha: 0.15),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 18),
          Text(title, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text(value, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(subtitle, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
