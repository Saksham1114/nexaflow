class DailyBriefing {
  const DailyBriefing({
    required this.greeting,
    required this.summary,
    required this.recommendation,
    this.priorityTaskTitle,
    this.productivityScore,
  });

  final String greeting;
  final String summary;
  final String recommendation;
  final String? priorityTaskTitle;
  final double? productivityScore;
}

