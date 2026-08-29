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

  Map<String, dynamic> toJson() {
    return {
      'theme': theme.name,
      'notificationsEnabled': notificationsEnabled,
      'dailyGoal': dailyGoal,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      theme: ThemeModeOption.values.firstWhere(
        (e) => e.name == json['theme'],
        orElse: () => ThemeModeOption.system,
      ),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      dailyGoal: json['dailyGoal'] as int? ?? 3000,
    );
  }
}
