import 'package:flutter/material.dart';

class FocusTimer extends StatelessWidget {
  const FocusTimer({
    super.key,
    required this.remaining,
    this.isRunning = false,
  });

  final Duration remaining;
  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final minutes = remaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds = remaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$minutes:$seconds",
          style: theme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isRunning
                ? theme.colorScheme.primary.withAlpha(30)
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isRunning ? Icons.fiber_manual_record : Icons.pause_circle_outline,
                size: 10,
                color: isRunning ? theme.colorScheme.primary : theme.hintColor,
              ),
              const SizedBox(width: 4),
              Text(
                isRunning ? "RUNNING" : "PAUSED",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: isRunning
                      ? theme.colorScheme.primary
                      : theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

