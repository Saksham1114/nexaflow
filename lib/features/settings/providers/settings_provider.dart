import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/storage_service.dart';
import '../models/app_settings.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier(this._storage) : super(_loadInitialSettings(_storage));

  final StorageService _storage;
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

  void setTheme(ThemeModeOption mode) {
    state = state.copyWith(theme: mode);
    _persist();
  }

  void toggleNotifications(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
    _persist();
  }

  void setDailyGoal(int goal) {
    state = state.copyWith(dailyGoal: goal);
    _persist();
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return SettingsNotifier(storage);
});

