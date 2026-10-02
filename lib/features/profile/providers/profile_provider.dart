import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
    this.avatarImagePath,
  });

  final String name;
  final int avatarIndex;
  final String? avatarImagePath;

  ProfileMetadata copyWith({
    String? name,
    int? avatarIndex,
    String? avatarImagePath,
    bool clearImagePath = false,
  }) {
    return ProfileMetadata(
      name: name ?? this.name,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      avatarImagePath:
          clearImagePath ? null : (avatarImagePath ?? this.avatarImagePath),
    );
  }
}

class ProfileMetadataNotifier extends StateNotifier<ProfileMetadata> {
  ProfileMetadataNotifier(this._storage)
      : super(
          ProfileMetadata(
            name:
                _storage.getString('nexaflow_user_name') ?? 'NexaFlow Champion',
            avatarIndex: _storage.getInt('nexaflow_user_avatar') ?? 0,
            avatarImagePath:
                _storage.getString('nexaflow_user_avatar_image'),
          ),
        );

  final StorageService _storage;
  final ImagePicker _picker = ImagePicker();

  Future<void> updateName(String name) async {
    final clean = name.trim();
    if (clean.isEmpty) return;
    await _storage.setString('nexaflow_user_name', clean);
    state = state.copyWith(name: clean);
  }

  Future<void> updateAvatar(int index) async {
    await _storage.setInt('nexaflow_user_avatar', index);
    // When an avatar icon is selected, clear custom image
    await _storage.remove('nexaflow_user_avatar_image');
    state = state.copyWith(avatarIndex: index, clearImagePath: true);
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 600,
        maxHeight: 600,
      );

      if (pickedFile != null) {
        await _storage.setString(
            'nexaflow_user_avatar_image', pickedFile.path);
        state = state.copyWith(avatarImagePath: pickedFile.path);
      }
    } catch (_) {
      // Handle permission denied or cancellation gracefully
    }
  }

  Future<void> removeProfileImage() async {
    await _storage.remove('nexaflow_user_avatar_image');
    state = state.copyWith(clearImagePath: true);
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
    avatarImagePath: meta.avatarImagePath,
    totalTasksCompleted: completedTasks,
    totalHabitsCompleted: completedHabits,
    totalFocusMinutes: focusMinutes,
    totalWaterDrunk: totalWater,
    currentStreak: streak.currentStreak,
    bestStreak: streak.bestStreak,
    xp: totalXp,
  );
});

