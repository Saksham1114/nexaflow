import 'package:flutter/material.dart';

class AchievementBadge {
  const AchievementBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    required this.progress,
    required this.target,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final int progress;
  final int target;

  double get progressPercentage => (progress / target).clamp(0.0, 1.0);
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.avatarIndex,
    this.avatarImagePath,
    required this.totalTasksCompleted,
    required this.totalHabitsCompleted,
    required this.totalFocusMinutes,
    required this.totalWaterDrunk,
    required this.currentStreak,
    required this.bestStreak,
    required this.xp,
  });

  final String name;
  final int avatarIndex;
  final String? avatarImagePath;
  final int totalTasksCompleted;
  final int totalHabitsCompleted;
  final int totalFocusMinutes;
  final int totalWaterDrunk;
  final int currentStreak;
  final int bestStreak;
  final int xp;


  static const int xpPerLevel = 500;

  int get level => (xp / xpPerLevel).floor() + 1;
  int get currentLevelXp => xp % xpPerLevel;
  double get levelProgress => (currentLevelXp / xpPerLevel).clamp(0.0, 1.0);

  String get rankTitle {
    final lvl = level;
    if (lvl >= 20) return "Titan of Productivity 👑";
    if (lvl >= 15) return "Focus Grandmaster 💎";
    if (lvl >= 10) return "Master of Flow 🏆";
    if (lvl >= 6) return "Consistency Warrior ⚡";
    if (lvl >= 3) return "Habit Builder 🌱";
    return "Novice Achiever 🚀";
  }

  List<AchievementBadge> get badges {
    return [
      AchievementBadge(
        id: 'first_step',
        title: 'First Step',
        description: 'Complete your first task',
        icon: Icons.check_circle_outline,
        color: Colors.green,
        isUnlocked: totalTasksCompleted >= 1,
        progress: totalTasksCompleted.clamp(0, 1),
        target: 1,
      ),
      AchievementBadge(
        id: 'task_slayer',
        title: 'Task Slayer',
        description: 'Complete 10 total tasks',
        icon: Icons.bolt_outlined,
        color: Colors.amber,
        isUnlocked: totalTasksCompleted >= 10,
        progress: totalTasksCompleted.clamp(0, 10),
        target: 10,
      ),
      AchievementBadge(
        id: 'streak_igniter',
        title: 'Flame Keeper',
        description: 'Achieve a 3-day streak',
        icon: Icons.local_fire_department_outlined,
        color: Colors.deepOrange,
        isUnlocked: bestStreak >= 3,
        progress: bestStreak.clamp(0, 3),
        target: 3,
      ),
      AchievementBadge(
        id: 'streak_warrior',
        title: '7-Day Titan',
        description: 'Build an unbroken 7-day streak',
        icon: Icons.workspace_premium_outlined,
        color: Colors.purple,
        isUnlocked: bestStreak >= 7,
        progress: bestStreak.clamp(0, 7),
        target: 7,
      ),
      AchievementBadge(
        id: 'hydration_hero',
        title: 'Hydration Hero',
        description: 'Drink over 3,000 ml of water',
        icon: Icons.water_drop_outlined,
        color: Colors.blue,
        isUnlocked: totalWaterDrunk >= 3000,
        progress: totalWaterDrunk.clamp(0, 3000),
        target: 3000,
      ),
      AchievementBadge(
        id: 'deep_focus',
        title: 'Zen Master',
        description: 'Complete 50 minutes of deep focus',
        icon: Icons.timer_outlined,
        color: Colors.indigo,
        isUnlocked: totalFocusMinutes >= 50,
        progress: totalFocusMinutes.clamp(0, 50),
        target: 50,
      ),
    ];
  }

  int get unlockedBadgeCount => badges.where((b) => b.isUnlocked).length;

  UserProfile copyWith({
    String? name,
    int? avatarIndex,
    String? avatarImagePath,
    bool clearImagePath = false,
    int? totalTasksCompleted,
    int? totalHabitsCompleted,
    int? totalFocusMinutes,
    int? totalWaterDrunk,
    int? currentStreak,
    int? bestStreak,
    int? xp,
  }) {
    return UserProfile(
      name: name ?? this.name,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      avatarImagePath: clearImagePath ? null : (avatarImagePath ?? this.avatarImagePath),
      totalTasksCompleted: totalTasksCompleted ?? this.totalTasksCompleted,
      totalHabitsCompleted: totalHabitsCompleted ?? this.totalHabitsCompleted,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      totalWaterDrunk: totalWaterDrunk ?? this.totalWaterDrunk,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      xp: xp ?? this.xp,
    );
  }
}

