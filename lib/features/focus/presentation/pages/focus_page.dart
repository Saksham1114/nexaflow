import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/focus_provider.dart';
import '../widgets/focus_controls.dart';
import '../widgets/focus_timer.dart';
import '../widgets/focus_progress_ring.dart';
import '../../providers/focus_statistics_provider.dart';

class FocusPage extends ConsumerWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(focusProvider);
    final notifier = ref.read(focusProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Focus Mode")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FocusProgressRing(
              progress: session.progress,
              child: FocusTimer(remaining: session.remaining),
            ),

            const SizedBox(height: 32),

            LinearProgressIndicator(value: session.progress),

            const SizedBox(height: 32),

            FocusControls(
              isRunning: session.isRunning,
              onStart: notifier.start,
              onPause: notifier.pause,
              onReset: notifier.reset,
            ),

            const SizedBox(height: 32),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Consumer(
                  builder: (context, ref, _) {
                    final stats = ref.watch(focusStatisticsProvider);

                    return Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.timer),
                          title: const Text("Today's Focus"),
                          trailing: Text("${stats.totalMinutes} min"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.check_circle),
                          title: const Text("Sessions"),
                          trailing: Text("${stats.sessionsToday}"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.workspace_premium),
                          title: const Text("Longest Session"),
                          trailing: Text("${stats.longestSession} min"),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            Text(
              "Completed Sessions: ${session.completedSessions}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
