enum ThemeModeOption { system, light, dark }

class AppSettings {
  const AppSettings({
    required this.theme,
    required this.notificationsEnabled,
    required this.dailyGoal,
  });

  final ThemeModeOption theme;
  final bool notificationsEnabled;
  final int dailyGoal;

  AppSettings copyWith({
    ThemeModeOption? theme,
    bool? notificationsEnabled,
    int? dailyGoal,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyGoal: dailyGoal ?? this.dailyGoal,
    );
  }
}
