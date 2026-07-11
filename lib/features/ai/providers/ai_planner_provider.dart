import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ai_task_plan.dart';
import '../services/ai_planner_service.dart';

final aiPlannerServiceProvider = Provider((ref) => const AIPlannerService());

final aiPlannerProvider = Provider.family<AITaskPlan, String>((ref, goal) {
  return ref.read(aiPlannerServiceProvider).generatePlan(goal);
});
