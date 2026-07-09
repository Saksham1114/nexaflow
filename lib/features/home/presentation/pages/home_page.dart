import 'package:flutter/material.dart';

import 'package:nexaflow/features/home/presentation/widgets/greeting_header.dart';
import 'package:nexaflow/features/home/presentation/widgets/productivity_card.dart';
import 'package:nexaflow/features/home/presentation/widgets/quick_action_card.dart';
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
            ],
          ),
        ),
      ),
    );
  }
}
