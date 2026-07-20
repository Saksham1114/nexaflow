import '../../../core/services/notification_service.dart';

class TaskNotificationService {
  const TaskNotificationService();

  Future<void> taskCreated(String title) async {
    await NotificationService.instance.showInstantNotification(
      title: "Task Created",
      body: title,
    );
  }

  Future<void> taskCompleted(String title) async {
    await NotificationService.instance.showInstantNotification(
      title: "Task Completed 🎉",
      body: title,
    );
  }
}
