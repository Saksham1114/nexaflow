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

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text("Appearance", style: Theme.of(context).textTheme.titleLarge),

          const SizedBox(height: 12),

          SettingsTile(
            icon: Icons.palette_outlined,
            title: "Theme",
            subtitle: settings.theme.name.toUpperCase(),
            trailing: DropdownButton<ThemeModeOption>(
              value: settings.theme,
              underline: const SizedBox.shrink(),
              items: ThemeModeOption.values.map((theme) {
                return DropdownMenuItem(
                  value: theme,
                  child: Text(theme.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                notifier.setTheme(value);
              },
            ),
          ),

          const SizedBox(height: 24),

          Text("Notifications", style: Theme.of(context).textTheme.titleLarge),

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
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "${settings.dailyGoal} ml",
                    style: Theme.of(context).textTheme.headlineSmall,
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

          Text("About", style: Theme.of(context).textTheme.titleLarge),

          const SizedBox(height: 12),

          const SettingsTile(
            icon: Icons.info_outline,
            title: "Version",
            subtitle: "1.0.0",
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
