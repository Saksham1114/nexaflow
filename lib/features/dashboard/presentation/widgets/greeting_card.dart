import 'package:flutter/material.dart';

import '../../../../shared/widgets/dashboard_card.dart';

class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  String get greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) return "Good Morning";

    if (hour < 17) return "Good Afternoon";

    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$greeting 👋",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  "Let's make today productive.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const CircleAvatar(radius: 28, child: Icon(Icons.auto_awesome)),
        ],
      ),
    );
  }
}
