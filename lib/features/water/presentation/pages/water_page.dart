import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nexaflow/features/water/providers/water_provider.dart';
import 'package:nexaflow/features/settings/providers/settings_provider.dart';

class WaterPage extends ConsumerWidget {
  const WaterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(waterProvider);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(waterProvider.notifier);

    final total = entries.fold<int>(0, (sum, e) => sum + e.amount);
    final goal = settings.dailyGoal > 0 ? settings.dailyGoal : 3000;

    final progress = (total / goal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: const Text("Water Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircularProgressIndicator(value: progress, strokeWidth: 10),

            const SizedBox(height: 24),

            Text(
              "$total ml / $goal ml",
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 32),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: () => notifier.addWater(250),
                  child: const Text("+250 ml"),
                ),
                FilledButton(
                  onPressed: () => notifier.addWater(500),
                  child: const Text("+500 ml"),
                ),
                FilledButton(
                  onPressed: () => notifier.addWater(750),
                  child: const Text("+750 ml"),
                ),
              ],
            ),

            const SizedBox(height: 24),

            FilledButton.tonal(
              onPressed: notifier.clearToday,
              child: const Text("Reset"),
            ),
          ],
        ),
      ),
    );
  }
}
