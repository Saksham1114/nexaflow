import 'package:flutter/material.dart';

import 'package:nexaflow/features/home/presentation/widgets/greeting_header.dart';
import 'package:nexaflow/features/home/presentation/widgets/productivity_card.dart';
import 'package:nexaflow/features/home/presentation/widgets/quick_action_card.dart';
import 'package:nexaflow/features/home/presentation/widgets/stat_card.dart';
import 'package:nexaflow/shared/widgets/section_title.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/providers/dashboard_provider.dart';

import '../../../tasks/providers/task_provider.dart';
import '../widgets/recent_task_tile.dart';
import '../widgets/streak_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final stats = ref.watch(dashboardStatsProvider);

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

              const SizedBox(height: 24),

              const StreakCard(currentStreak: 5),

              const SizedBox(height: 32),

              const SectionTitle("Today's Progress"),

              const ProductivityCard(),

              const SizedBox(height: 32),

              const SectionTitle("Quick Actions"),

              Row(
                children: [
                  QuickActionCard(
                    title: "Tasks",
                    icon: Icons.add_task_rounded,
                    color: Colors.blue,
                    onTap: () => context.go('/tasks'),
                  ),
                  const SizedBox(width: 16),
                  QuickActionCard(
                    title: "AI",
                    icon: Icons.auto_awesome,
                    color: Colors.deepPurple,
                    onTap: () => context.go('/ai'),
                  ),
                  const SizedBox(width: 16),
                  QuickActionCard(
                    title: "Water",
                    icon: Icons.water_drop,
                    color: Colors.cyan,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Water tracker will be added soon."),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const SectionTitle("Today's Overview"),

              Row(
                children: [
                  StatCard(
                    title: "Tasks",
                    value: "${stats.completedTasks}/${stats.totalTasks}",
                    subtitle: "Completed",
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                  ),
                  SizedBox(width: 16),
                  StatCard(
                    title: "Water",
                    value: "${(stats.totalWater / 1000).toStringAsFixed(1)}L",
                    subtitle: "Today",
                    icon: Icons.water_drop,
                    iconColor: Colors.cyan,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  StatCard(
                    title: "Habits",
                    value: "${stats.completedHabits}/${stats.totalHabits}",
                    subtitle: "Completed",
                    icon: Icons.local_fire_department,
                    iconColor: Colors.orange,
                  ),
                  SizedBox(width: 16),
                  StatCard(
                    title: "Focus",
                    value: "${(stats.productivity * 100).round()}%",
                    subtitle: "Today's Score",
                    icon: Icons.bolt,
                    iconColor: Colors.amber,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const SectionTitle("Recent Tasks"),

              const SizedBox(height: 16),

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

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
