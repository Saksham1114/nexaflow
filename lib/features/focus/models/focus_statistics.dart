class FocusStatistics {
  const FocusStatistics({
    required this.totalMinutes,
    required this.sessionsToday,
    required this.longestSession,
  });

  final int totalMinutes;
  final int sessionsToday;
  final int longestSession;
}
