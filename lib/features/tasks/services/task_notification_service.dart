import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/notification_service.dart';
import '../models/task.dart';

class TaskNotificationService {
  const TaskNotificationService(this._notificationService);

  final NotificationService _notificationService;

  int _getNotificationId(String taskId) {
    return taskId.hashCode.abs() % 100000;
  }

  Future<void> scheduleTaskReminder(Task task) async {
    if (task.dueDate == null || task.isCompleted) return;

    final notifId = _getNotificationId(task.id);
    await _notificationService.scheduleNotification(
      id: notifId,
      title: 'Task Due: ${task.title}',
      body: task.description.isNotEmpty
          ? task.description
          : 'Your task is due now!',
      scheduledDate: task.dueDate!,
      channelId: NotificationService.taskChannelId,
      channelName: 'Tasks',
      channelDescription: 'Task due date notifications',
    );
  }

  Future<void> cancelTaskReminder(String taskId) async {
    final notifId = _getNotificationId(taskId);
    await _notificationService.cancelNotification(notifId);
  }

  Future<void> taskCreated(Task task) async {
    if (task.dueDate != null) {
      await scheduleTaskReminder(task);
    }
  }

  Future<void> taskCompleted(Task task) async {
    await cancelTaskReminder(task.id);
    await _notificationService.showInstantNotification(
      title: 'Task Completed! 🎉',
      body: 'Great job completing "${task.title}"',
      channelId: NotificationService.taskChannelId,
    );
  }
}

final taskNotificationServiceProvider =
    Provider<TaskNotificationService>((ref) {
  final notifService = ref.watch(notificationServiceProvider);
  return TaskNotificationService(notifService);
});

