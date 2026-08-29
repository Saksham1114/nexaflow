import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/notification_service.dart';

class WaterNotificationService {
  const WaterNotificationService(this._notificationService);

  final NotificationService _notificationService;

  static const List<int> reminderHours = [10, 14, 18];
  static const int baseReminderId = 3000;

  Future<void> scheduleHydrationReminders() async {
    for (int i = 0; i < reminderHours.length; i++) {
      final hour = reminderHours[i];
      await _notificationService.scheduleDailyNotification(
        id: baseReminderId + i,
        title: 'Time to Hydrate 💧',
        body: 'Drink a glass of water to stay energized and focused!',
        hour: hour,
        minute: 0,
        channelId: NotificationService.waterChannelId,
        channelName: 'Hydration',
        channelDescription: 'Daily water intake reminders',
      );
    }
  }

  Future<void> cancelHydrationReminders() async {
    for (int i = 0; i < reminderHours.length; i++) {
      await _notificationService.cancelNotification(baseReminderId + i);
    }
  }

  Future<void> waterGoalReached(int goalMl) async {
    await _notificationService.showInstantNotification(
      title: 'Hydration Goal Reached! 🌊',
      body: 'You drank $goalMl ml of water today. Outstanding work!',
      channelId: NotificationService.waterChannelId,
      channelName: 'Hydration',
      channelDescription: 'Hydration celebration',
    );
  }
}

final waterNotificationServiceProvider =
    Provider<WaterNotificationService>((ref) {
  final notifService = ref.watch(notificationServiceProvider);
  return WaterNotificationService(notifService);
});
