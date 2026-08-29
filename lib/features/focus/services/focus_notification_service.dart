import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/notification_service.dart';

class FocusNotificationService {
  const FocusNotificationService(this._notificationService);

  final NotificationService _notificationService;

  static const int focusCompletionId = 4001;

  Future<void> notifySessionCompleted(int minutes) async {
    await _notificationService.showInstantNotification(
      id: focusCompletionId,
      title: 'Focus Session Completed! 🎯',
      body: 'Awesome focus! You completed $minutes minutes of deep work.',
      channelId: NotificationService.focusChannelId,
      channelName: 'Focus Timer',
      channelDescription: 'Pomodoro timer alerts',
    );
  }
}

final focusNotificationServiceProvider =
    Provider<FocusNotificationService>((ref) {
  final notifService = ref.watch(notificationServiceProvider);
  return FocusNotificationService(notifService);
});
