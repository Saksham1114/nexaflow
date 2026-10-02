import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/streak_provider.dart';
import '../../providers/focus_provider.dart';
import '../../providers/focus_statistics_provider.dart';
import '../widgets/focus_controls.dart';
import '../widgets/focus_progress_ring.dart';
import '../widgets/focus_timer.dart';

class FocusPage extends ConsumerWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(focusProvider);
    final notifier = ref.read(focusProvider.notifier);
    final theme = Theme.of(context);
    final streak = ref.watch(streakProvider);

    final currentMinutes = session.duration.inMinutes;

    final modes = [
      {'label': '🎯 Focus', 'minutes': 25},
      {'label': '☕ Short Break', 'minutes': 5},
      {'label': '🌴 Long Break', 'minutes': 15},
      {'label': '⚡ Deep Work', 'minutes': 45},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Focus Timer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: "Pomodoro Technique",
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Pomodoro Technique"),
                  content: const Text(
                    "Work with full concentration for 25 minutes, then take a 5-minute break.\n\n"
                    "After completing 4 focus intervals, reward yourself with a longer 15-minute rest.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Got it"),
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
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Mode Selector Chips
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: modes.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final mode = modes[index];
                    final minutes = mode['minutes'] as int;
                    final isSelected = currentMinutes == minutes;

                    return ChoiceChip(
                      label: Text(mode['label'] as String),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected && !session.isRunning) {
                          notifier.setDuration(Duration(minutes: minutes));
                        }
                      },
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                      ),
                      selectedColor: theme.colorScheme.primary,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      side: BorderSide(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.dividerColor.withAlpha(30),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 36),

              // Progress Ring & Timer
              FocusProgressRing(
                progress: session.progress,
                child: FocusTimer(
                  remaining: session.remaining,
                  isRunning: session.isRunning,
                ),
              ),

              const SizedBox(height: 36),

              // Play / Pause / Reset Controls
              FocusControls(
                isRunning: session.isRunning,
                onStart: notifier.start,
                onPause: notifier.pause,
                onReset: notifier.reset,
              ),

              const SizedBox(height: 36),

              // Daily Statistics Grid Cards
              Consumer(
                builder: (context, ref, _) {
                  final stats = ref.watch(focusStatisticsProvider);

                  return Row(
                    children: [
                      Expanded(
                        child: _StatBox(
                          icon: Icons.timer_outlined,
                          value: "${stats.totalMinutes}m",
                          label: "Today's Focus",
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatBox(
                          icon: Icons.check_circle_outline,
                          value: "${stats.sessionsToday}",
                          label: "Sessions",
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatBox(
                          icon: Icons.local_fire_department_outlined,
                          value: "${streak.currentStreak}d",
                          label: "Streak",
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // Motivational Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor.withAlpha(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: theme.colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        session.isRunning
                            ? "Silence distractions. You are building powerful momentum!"
                            : "Ready to enter the flow state? Tap Start to begin.",
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
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

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withAlpha(30),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: theme.hintColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

