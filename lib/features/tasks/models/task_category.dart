enum TaskCategory { work, personal, study, health, finance, shopping }

extension TaskCategoryExtension on TaskCategory {
  String get title {
    switch (this) {
      case TaskCategory.work:
        return "Work";

      case TaskCategory.personal:
        return "Personal";

      case TaskCategory.study:
        return "Study";

      case TaskCategory.health:
        return "Health";

      case TaskCategory.finance:
        return "Finance";

      case TaskCategory.shopping:
        return "Shopping";
    }
  }
}
