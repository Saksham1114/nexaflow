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
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 260,
            height: 260,
            child: CircularProgressIndicator(value: progress, strokeWidth: 10),
          ),
          child,
        ],
      ),
    );
  }
}
