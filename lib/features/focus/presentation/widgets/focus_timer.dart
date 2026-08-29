import 'package:flutter/material.dart';

class FocusTimer extends StatelessWidget {
  const FocusTimer({super.key, required this.remaining});

  final Duration remaining;

  @override
  Widget build(BuildContext context) {
    final minutes = remaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds = remaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return Center(
      child: Text(
        "$minutes:$seconds",
        style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
      ),
    );
  }
}
