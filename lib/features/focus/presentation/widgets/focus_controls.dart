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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton.icon(
          onPressed: isRunning ? onPause : onStart,
          icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
          label: Text(isRunning ? "Pause" : "Start"),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.refresh),
          label: const Text("Reset"),
        ),
      ],
    );
  }
}
