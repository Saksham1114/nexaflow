import 'package:flutter/material.dart';

class FocusProgressRing extends StatelessWidget {
  const FocusProgressRing({
    super.key,
    required this.progress,
    required this.child,
  });

  final double progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background track
          SizedBox(
            width: 240,
            height: 240,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation(
                theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          // Active progress
          SizedBox(
            width: 240,
            height: 240,
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation(
                theme.colorScheme.primary,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

