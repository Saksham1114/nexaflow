import 'package:flutter/material.dart';

import '../widgets/daily_quote_card.dart';
import '../widgets/greeting_card.dart';
import '../widgets/overview_stat_card.dart';
import '../widgets/productivity_score_card.dart';
import '../widgets/progress_overview_card.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/section_title.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NexaFlow")),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GreetingCard(),

            const SizedBox(height: 20),

            SectionTitle(title: "Overview"),

            const SizedBox(height: 16),

            ProgressOverviewCard(),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OverviewStatCard(
                    title: "Tasks",
                    value: "7",
                    subtitle: "Completed",
                    icon: Icons.task_alt,
                    iconColor: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OverviewStatCard(
                    title: "Water",
                    value: "2.5L",
                    subtitle: "Today",
                    icon: Icons.water_drop,
                    iconColor: Colors.cyan,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ProductivityScoreCard(),

            const SizedBox(height: 20),

            QuickActionsCard(),

            const SizedBox(height: 20),

            DailyQuoteCard(),
          ],
        ),
      ),
    );
  }
}
