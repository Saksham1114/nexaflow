import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nexaflow/app/router.dart';
import 'package:nexaflow/app/theme/app_theme.dart';
import 'package:nexaflow/features/settings/models/app_settings.dart';
import 'package:nexaflow/features/settings/providers/settings_provider.dart';

class NexaFlowApp extends ConsumerWidget {
  const NexaFlowApp({super.key});

  ThemeMode _mapThemeMode(ThemeModeOption option) {
    switch (option) {
      case ThemeModeOption.system:
        return ThemeMode.system;
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: 'NexaFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _mapThemeMode(settings.theme),
      routerConfig: AppRouter.router,
    );
  }
}
