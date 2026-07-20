import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier()
    : super(
        const AppSettings(
          theme: ThemeModeOption.system,
          notificationsEnabled: true,
          dailyGoal: 4000,
        ),
      );

  void setTheme(ThemeModeOption mode) {
    state = state.copyWith(theme: mode);
  }

  void toggleNotifications(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
  }

  void setDailyGoal(int goal) {
    state = state.copyWith(dailyGoal: goal);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);
