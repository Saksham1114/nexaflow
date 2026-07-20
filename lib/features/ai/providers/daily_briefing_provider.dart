import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dashboard/providers/dashboard_provider.dart';
import '../models/daily_briefing.dart';
import '../services/daily_briefing_service.dart';

final dailyBriefingProvider = Provider<DailyBriefing>((ref) {
  final stats = ref.watch(dashboardStatsProvider);

  return const DailyBriefingService().generate(
    pendingTasks: stats.totalTasks - stats.completedTasks,
    completedTasks: stats.completedTasks,
    water: stats.totalWater,
    habitsCompleted: stats.completedHabits,
  );
});
