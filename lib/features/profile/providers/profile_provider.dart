import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/streak_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../focus/providers/focus_provider.dart';
import '../../habits/providers/habit_provider.dart';
import '../../tasks/providers/task_provider.dart';
import '../../water/providers/water_provider.dart';
import '../models/user_profile.dart';

class ProfileMetadata {
  const ProfileMetadata({
    required this.name,
    required this.avatarIndex,
  });

  final String name;
  final int avatarIndex;

  ProfileMetadata copyWith({
    String? name,
    int? avatarIndex,
  }) {
    return ProfileMetadata(
      name: name ?? this.name,
      avatarIndex: avatarIndex ?? this.avatarIndex,
    );
  }
}

class ProfileMetadataNotifier extends StateNotifier<ProfileMetadata> {
  ProfileMetadataNotifier(this._storage)
      : super(
          ProfileMetadata(
            name: _storage.getString('nexaflow_user_name') ?? 'NexaFlow Champion',
            avatarIndex: _storage.getInt('nexaflow_user_avatar') ?? 0,
          ),
        );

  final StorageService _storage;

  Future<void> updateName(String name) async {
    final clean = name.trim();
    if (clean.isEmpty) return;
    await _storage.setString('nexaflow_user_name', clean);
    state = state.copyWith(name: clean);
  }

  Future<void> updateAvatar(int index) async {
    await _storage.setInt('nexaflow_user_avatar', index);
    state = state.copyWith(avatarIndex: index);
  }
}

final profileMetadataProvider =
    StateNotifierProvider<ProfileMetadataNotifier, ProfileMetadata>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ProfileMetadataNotifier(storage);
});

final userProfileProvider = Provider<UserProfile>((ref) {
  final meta = ref.watch(profileMetadataProvider);
  final tasks = ref.watch(taskProvider);
  final habits = ref.watch(habitProvider);
  final waterEntries = ref.watch(waterProvider);
  final focus = ref.watch(focusProvider);
  final streak = ref.watch(streakProvider);

  final completedTasks = tasks.where((t) => t.isCompleted).length;
  final completedHabits = habits.where((h) => h.completedToday).length;
  final totalWater = waterEntries.fold<int>(0, (sum, e) => sum + e.amount);
  final focusMinutes = focus.completedSessions * focus.duration.inMinutes;

  // XP calculation algorithm
  final taskXp = completedTasks * 50;
  final habitXp = completedHabits * 30;
  final waterXp = ((totalWater / 250).floor() * 10);
  final focusXp = focus.completedSessions * 100;
  final streakXp = streak.currentStreak * 150;

  final totalXp = taskXp + habitXp + waterXp + focusXp + streakXp;

  return UserProfile(
    name: meta.name,
    avatarIndex: meta.avatarIndex,
    totalTasksCompleted: completedTasks,
    totalHabitsCompleted: completedHabits,
    totalFocusMinutes: focusMinutes,
    totalWaterDrunk: totalWater,
    currentStreak: streak.currentStreak,
    bestStreak: streak.bestStreak,
    xp: totalXp,
  );
});
