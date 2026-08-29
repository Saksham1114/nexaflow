import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/notification_service.dart';
import '../models/habit.dart';

class HabitNotificationService {
  const HabitNotificationService(this._notificationService);

  final NotificationService _notificationService;

  static const int morningReminderId = 2001;
  static const int eveningReminderId = 2002;

  Future<void> scheduleDailyHabitReminders() async {
    // 9:00 AM Morning Check-in
    await _notificationService.scheduleDailyNotification(
      id: morningReminderId,
      title: 'Morning Habit Check-in ☀️',
      body: "Start your day strong! Complete your morning habits.",
      hour: 9,
      minute: 0,
      channelId: NotificationService.habitChannelId,
      channelName: 'Habits',
      channelDescription: 'Daily habit check-in reminders',
    );

    // 8:00 PM Evening Review
    await _notificationService.scheduleDailyNotification(
      id: eveningReminderId,
      title: 'Evening Habit Review 🌙',
      body: "Keep your streak alive! Review and finish remaining habits today.",
      hour: 20,
      minute: 0,
      channelId: NotificationService.habitChannelId,
      channelName: 'Habits',
      channelDescription: 'Daily habit check-in reminders',
    );
  }

  Future<void> cancelDailyReminders() async {
    await _notificationService.cancelNotification(morningReminderId);
    await _notificationService.cancelNotification(eveningReminderId);
  }

  Future<void> habitCompleted(Habit habit) async {
    await _notificationService.showInstantNotification(
      title: 'Habit Completed! ⚡',
      body: 'Way to go! You completed "${habit.title}"',
      channelId: NotificationService.habitChannelId,
      channelName: 'Habits',
      channelDescription: 'Daily habit notifications',
    );
  }
}

final habitNotificationServiceProvider =
    Provider<HabitNotificationService>((ref) {
  final notifService = ref.watch(notificationServiceProvider);
  return HabitNotificationService(notifService);
});
