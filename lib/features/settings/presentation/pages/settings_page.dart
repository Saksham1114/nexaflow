import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/settings_provider.dart';
import '../../models/app_settings.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // App Logo & Branding Banner
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/icons/app_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "NexaFlow",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "AI-Powered Personal Productivity OS",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          Text("Appearance", style: theme.textTheme.titleLarge),

          const SizedBox(height: 12),

          SettingsTile(
            icon: Icons.palette_outlined,
            title: "Theme",
            subtitle: settings.theme.name.toUpperCase(),
            trailing: DropdownButton<ThemeModeOption>(
              value: settings.theme,
              underline: const SizedBox.shrink(),
              items: ThemeModeOption.values.map((themeOption) {
                return DropdownMenuItem(
                  value: themeOption,
                  child: Text(themeOption.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                notifier.setTheme(value);
              },
            ),
          ),

          const SizedBox(height: 24),

          Text("Notifications", style: theme.textTheme.titleLarge),

          const SizedBox(height: 12),

          SettingsTile(
            icon: Icons.notifications_active_outlined,
            title: "Enable Notifications",
            trailing: Switch(
              value: settings.notificationsEnabled,
              onChanged: notifier.toggleNotifications,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            "Daily Water Goal",
            style: theme.textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "${settings.dailyGoal} ml",
                    style: theme.textTheme.headlineSmall,
                  ),
                  Slider(
                    value: settings.dailyGoal.toDouble(),
                    min: 1000,
                    max: 6000,
                    divisions: 10,
                    label: "${settings.dailyGoal} ml",
                    onChanged: (value) {
                      notifier.setDailyGoal(value.toInt());
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          Text("About", style: theme.textTheme.titleLarge),

          const SizedBox(height: 12),

          const SettingsTile(
            icon: Icons.info_outline,
            title: "Version",
            subtitle: "1.0.0 (Build 1)",
          ),

          const SettingsTile(
            icon: Icons.code,
            title: "Built with Flutter",
            subtitle: "NexaFlow AI Productivity OS",
          ),
        ],
      ),
    );
  }
}
