import 'package:flutter/material.dart';

import 'package:nexaflow/features/home/presentation/widgets/greeting_header.dart';
import 'package:nexaflow/features/home/presentation/widgets/productivity_card.dart';
import 'package:nexaflow/features/home/presentation/widgets/quick_action_card.dart';
import 'package:nexaflow/shared/widgets/section_title.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../tasks/providers/task_provider.dart';
import '../widgets/recent_task_tile.dart';
import '../widgets/streak_card.dart';
import '../../providers/daily_briefing_provider.dart';
import '../widgets/ai_briefing_card.dart';
import 'package:nexaflow/core/providers/streak_provider.dart';
import 'package:nexaflow/features/dashboard/presentation/widgets/dashboard_overview_card.dart';
import 'package:nexaflow/features/dashboard/providers/dashboard_overview_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final overview = ref.watch(dashboardOverviewProvider);
    final briefing = ref.watch(dailyBriefingProvider);
    final streak = ref.watch(streakProvider);

    final recentTasks = tasks
        .where((task) => !task.isCompleted)
        .take(3)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingHeader(),
              const SizedBox(height: 16),

              StreakCard(streak: streak),
              const SizedBox(height: 16),

              AIBriefingCard(
                greeting: briefing.greeting,
                summary: briefing.summary,
                recommendation: briefing.recommendation,
              ),
              const SizedBox(height: 16),

              DashboardOverviewCard(overview: overview),
              const SizedBox(height: 24),

              const SectionTitle("Today's Progress"),
              const SizedBox(height: 12),
              ProductivityCard(productivity: overview.productivity),

              const SizedBox(height: 28),

              const SectionTitle("Quick Actions"),
              const SizedBox(height: 12),

              Row(
                children: [
                  QuickActionCard(
                    title: "Tasks",
                    icon: Icons.add_task_rounded,
                    color: Colors.blue,
                    onTap: () => context.go('/tasks'),
                  ),
                  const SizedBox(width: 12),
                  QuickActionCard(
                    title: "Habits",
                    icon: Icons.local_fire_department_rounded,
                    color: Colors.orange,
                    onTap: () => context.go('/habits'),
                  ),
                  const SizedBox(width: 12),
                  QuickActionCard(
                    title: "Focus",
                    icon: Icons.timer_rounded,
                    color: Colors.amber,
                    onTap: () => context.go('/focus'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  QuickActionCard(
                    title: "AI Chat",
                    icon: Icons.auto_awesome,
                    color: Colors.deepPurple,
                    onTap: () => context.go('/ai'),
                  ),
                  const SizedBox(width: 12),
                  QuickActionCard(
                    title: "Water",
                    icon: Icons.water_drop,
                    color: Colors.cyan,
                    onTap: () => context.push('/water'),
                  ),
                  const SizedBox(width: 12),
                  QuickActionCard(
                    title: "Settings",
                    icon: Icons.settings_rounded,
                    color: Colors.grey,
                    onTap: () => context.go('/settings'),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const SectionTitle("Recent Tasks"),
              const SizedBox(height: 12),

              if (recentTasks.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        "No pending tasks 🎉",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                )
              else
                ...recentTasks.map(
                  (task) => RecentTaskTile(
                    task: task,
                    onTap: () => context.go('/tasks'),
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
