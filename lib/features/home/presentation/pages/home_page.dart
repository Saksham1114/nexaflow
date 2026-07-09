import 'package:flutter/material.dart';
import 'package:nexaflow/shared/widgets/dashboard_card.dart';
import 'package:nexaflow/shared/widgets/section_title.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Good Evening 👋", style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                "Welcome back to NexaFlow",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              const SectionTitle("Today's Progress"),

              DashboardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Productivity", style: theme.textTheme.titleLarge),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: const LinearProgressIndicator(
                        value: .72,
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("72% Complete", style: theme.textTheme.titleMedium),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const SectionTitle("Quick Actions"),

              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text("New Task"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text("Ask AI"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const SectionTitle("Today's Tasks"),

              const DashboardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "5 Tasks Pending",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("Let's make today productive 🚀"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
