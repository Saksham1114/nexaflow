import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../tasks/providers/task_provider.dart';
import '../models/daily_focus.dart';
import '../services/daily_focus_service.dart';

final dailyFocusProvider = Provider<DailyFocus>((ref) {
  final tasks = ref.watch(taskProvider);

  return const DailyFocusService().generate(tasks);
});
