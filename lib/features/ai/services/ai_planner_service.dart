import '../models/ai_task_plan.dart';

class AIPlannerService {
  const AIPlannerService();

  AITaskPlan generatePlan(String goal) {
    return AITaskPlan(
      title: goal,
      steps: [
        "Understand the objective",
        "Break it into smaller tasks",
        "Schedule daily work",
        "Track progress",
        "Review and improve",
      ],
    );
  }
}
