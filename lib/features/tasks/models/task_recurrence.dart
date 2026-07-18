enum TaskRecurrence { none, daily, weekly, monthly }

extension TaskRecurrenceExtension on TaskRecurrence {
  String get title {
    switch (this) {
      case TaskRecurrence.none:
        return "None";
      case TaskRecurrence.daily:
        return "Daily";
      case TaskRecurrence.weekly:
        return "Weekly";
      case TaskRecurrence.monthly:
        return "Monthly";
    }
  }

  String get shortTitle {
    switch (this) {
      case TaskRecurrence.none:
        return "";
      case TaskRecurrence.daily:
        return "Daily";
      case TaskRecurrence.weekly:
        return "Weekly";
      case TaskRecurrence.monthly:
        return "Monthly";
    }
  }
}
