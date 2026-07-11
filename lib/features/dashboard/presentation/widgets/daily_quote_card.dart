import 'package:flutter/material.dart';

import '../../../../shared/widgets/dashboard_card.dart';

class DailyQuoteCard extends StatelessWidget {
  const DailyQuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quote of the Day",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text("\"Discipline beats motivation every single day.\""),
        ],
      ),
    );
  }
}
