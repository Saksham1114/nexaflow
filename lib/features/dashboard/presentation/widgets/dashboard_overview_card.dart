import 'package:flutter/material.dart';

import '../../models/dashboard_overview.dart';

class DashboardOverviewCard extends StatelessWidget {
  const DashboardOverviewCard({super.key, required this.overview});

  final DashboardOverview overview;

  Widget buildRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Today's Overview",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            const SizedBox(height: 20),

            buildRow(
              Icons.check_circle,
              "Tasks",
              "${overview.completedTasks}/${overview.totalTasks}",
            ),

            buildRow(
              Icons.local_fire_department,
              "Habits",
              "${overview.completedHabits}/${overview.totalHabits}",
            ),

            buildRow(Icons.timer, "Focus", "${overview.focusMinutes} min"),

            buildRow(
              Icons.water_drop,
              "Water",
              "${overview.waterLiters.toStringAsFixed(1)} L",
            ),

            const Divider(height: 30),

            buildRow(
              Icons.auto_graph,
              "Productivity",
              "${(overview.productivity * 100).round()}%",
            ),
          ],
        ),
      ),
    );
  }
}
