import 'package:flutter/material.dart';

import 'package:nexaflow/features/home/presentation/widgets/greeting_header.dart';
import 'package:nexaflow/features/home/presentation/widgets/productivity_card.dart';
import 'package:nexaflow/features/home/presentation/widgets/quick_action_card.dart';
import 'package:nexaflow/features/home/presentation/widgets/stat_card.dart';
import 'package:nexaflow/shared/widgets/section_title.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingHeader(),

              const SizedBox(height: 32),

              const SectionTitle("Today's Progress"),

              const ProductivityCard(),

              const SizedBox(height: 32),

              const SectionTitle("Quick Actions"),

              Row(
                children: [
                  QuickActionCard(
                    title: "Task",
                    icon: Icons.add_task_rounded,
                    color: Colors.blue,
                    onTap: () {},
                  ),
                  const SizedBox(width: 16),
                  QuickActionCard(
                    title: "AI",
                    icon: Icons.auto_awesome,
                    color: Colors.deepPurple,
                    onTap: () {},
                  ),
                  const SizedBox(width: 16),
                  QuickActionCard(
                    title: "Water",
                    icon: Icons.water_drop,
                    color: Colors.cyan,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const SectionTitle("Today's Overview"),

              Row(
                children: const [
                  StatCard(
                    title: "Tasks",
                    value: "5",
                    subtitle: "Pending",
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                  ),
                  SizedBox(width: 16),
                  StatCard(
                    title: "Water",
                    value: "2.4L",
                    subtitle: "of 4L",
                    icon: Icons.water_drop,
                    iconColor: Colors.cyan,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: const [
                  StatCard(
                    title: "Habits",
                    value: "4/5",
                    subtitle: "Completed",
                    icon: Icons.local_fire_department,
                    iconColor: Colors.orange,
                  ),
                  SizedBox(width: 16),
                  StatCard(
                    title: "Focus",
                    value: "91%",
                    subtitle: "Today's Score",
                    icon: Icons.bolt,
                    iconColor: Colors.amber,
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
