import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/notification_service.dart';
import '../../../core/services/storage_service.dart';
import '../../habits/services/habit_notification_service.dart';
import '../../water/services/water_notification_service.dart';
import '../models/app_settings.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier(
    this._storage,
    this._notifService,
    this._habitNotifService,
    this._waterNotifService,
  ) : super(_loadInitialSettings(_storage)) {
    _syncNotificationSchedules();
  }

  final StorageService _storage;
  final NotificationService _notifService;
  final HabitNotificationService _habitNotifService;
  final WaterNotificationService _waterNotifService;

  static const String _storageKey = 'nexaflow_app_settings';

  static AppSettings _loadInitialSettings(StorageService storage) {
    final json = storage.getJson(_storageKey);
    if (json != null) {
      try {
        return AppSettings.fromJson(json);
      } catch (_) {}
    }
    return const AppSettings(
      theme: ThemeModeOption.system,
      notificationsEnabled: true,
      dailyGoal: 3000,
    );
  }

  void _persist() {
    _storage.setJson(_storageKey, state.toJson());
  }

  Future<void> _syncNotificationSchedules() async {
    if (state.notificationsEnabled) {
      await _habitNotifService.scheduleDailyHabitReminders();
      await _waterNotifService.scheduleHydrationReminders();
    } else {
      await _notifService.cancelAll();
    }
  }

  void setTheme(ThemeModeOption mode) {
    state = state.copyWith(theme: mode);
    _persist();
  }

  void toggleNotifications(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
    _persist();
    _syncNotificationSchedules();
  }

  void setDailyGoal(int goal) {
    state = state.copyWith(dailyGoal: goal);
    _persist();
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final notifService = ref.watch(notificationServiceProvider);
  final habitNotifService = ref.watch(habitNotificationServiceProvider);
  final waterNotifService = ref.watch(waterNotificationServiceProvider);

  return SettingsNotifier(
    storage,
    notifService,
    habitNotifService,
    waterNotifService,
  );
});


