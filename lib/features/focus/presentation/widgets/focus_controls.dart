import 'package:flutter/material.dart';

class FocusControls extends StatelessWidget {
  const FocusControls({
    super.key,
    required this.isRunning,
    required this.onStart,
    required this.onPause,
    required this.onReset,
  });

  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset Button
        IconButton.outlined(
          onPressed: onReset,
          icon: const Icon(Icons.replay_rounded),
          tooltip: "Reset Timer",
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(16),
            side: BorderSide(color: theme.dividerColor.withAlpha(50)),
          ),
        ),

        const SizedBox(width: 24),

        // Big Primary Play / Pause Button
        FilledButton.icon(
          onPressed: isRunning ? onPause : onStart,
          icon: Icon(
            isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: 28,
          ),
          label: Text(
            isRunning ? "PAUSE" : "START FOCUS",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }
}

