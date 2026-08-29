import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/focus_statistics.dart';
import 'focus_provider.dart';

final focusStatisticsProvider = Provider<FocusStatistics>((ref) {
  final session = ref.watch(focusProvider);

  return FocusStatistics(
    totalMinutes: session.completedSessions * session.duration.inMinutes,
    sessionsToday: session.completedSessions,
    longestSession: session.duration.inMinutes,
  );
});
