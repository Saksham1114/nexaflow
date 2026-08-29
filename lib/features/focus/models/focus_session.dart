class FocusSession {
  const FocusSession({
    required this.duration,
    required this.remaining,
    required this.isRunning,
    required this.completedSessions,
  });

  final Duration duration;
  final Duration remaining;
  final bool isRunning;
  final int completedSessions;

  double get progress => duration.inSeconds == 0
      ? 0
      : 1 - (remaining.inSeconds / duration.inSeconds);

  FocusSession copyWith({
    Duration? duration,
    Duration? remaining,
    bool? isRunning,
    int? completedSessions,
  }) {
    return FocusSession(
      duration: duration ?? this.duration,
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
      completedSessions: completedSessions ?? this.completedSessions,
    );
  }
}
