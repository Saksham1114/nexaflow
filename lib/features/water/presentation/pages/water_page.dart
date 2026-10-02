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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final total = entries.fold<int>(0, (sum, e) => sum + e.amount);
    final goal = settings.dailyGoal > 0 ? settings.dailyGoal : 3000;
    final progress = (total / goal).clamp(0.0, 1.0);
    final percent = (progress * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hydration Tracker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: "Reset Today's Log",
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Reset Water Log"),
                  content: const Text(
                    "Are you sure you want to reset today's hydration intake?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Cancel"),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        notifier.clearToday();
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Reset"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Hydration Gauge
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 190,
                        height: 190,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 14,
                          strokeCap: StrokeCap.round,
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.cyan.withValues(alpha: 0.12),
                          color: Colors.cyan,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.water_drop_rounded,
                            size: 36,
                            color: Colors.cyan,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "$percent%",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            "$total / $goal ml",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Quick Add Buttons
              Text(
                "Quick Log",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _QuickWaterButton(
                    amount: 250,
                    icon: Icons.local_drink_rounded,
                    label: "+250 ml",
                    onTap: () => notifier.addWater(250),
                  ),
                  const SizedBox(width: 12),
                  _QuickWaterButton(
                    amount: 500,
                    icon: Icons.opacity_rounded,
                    label: "+500 ml",
                    onTap: () => notifier.addWater(500),
                  ),
                  const SizedBox(width: 12),
                  _QuickWaterButton(
                    amount: 750,
                    icon: Icons.water_drop_rounded,
                    label: "+750 ml",
                    onTap: () => notifier.addWater(750),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Today's History Log
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Drink Log (${entries.length})",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (total >= goal)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, size: 14, color: Colors.green),
                          SizedBox(width: 4),
                          Text(
                            "Goal Met! 🏆",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              if (entries.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        "No water logged today yet. Stay hydrated! 💧",
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                ...entries.map((entry) {
                  final timeStr =
                      "${entry.time.hour.toString().padLeft(2, '0')}:${entry.time.minute.toString().padLeft(2, '0')}";
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.cyan.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.water_drop_rounded,
                          color: Colors.cyan,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        "+${entry.amount} ml",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        timeStr,
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black45,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickWaterButton extends StatelessWidget {
  const _QuickWaterButton({
    required this.amount,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final int amount;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: onTap,
        child: Column(
          children: [
            Icon(icon, size: 22, color: Colors.cyan),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
