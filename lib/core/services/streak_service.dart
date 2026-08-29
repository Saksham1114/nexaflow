import 'dart:math';
import '../models/streak_model.dart';
import 'storage_service.dart';

class StreakService {
  const StreakService(this._storage);

  final StorageService _storage;

  static const String _datesKey = 'nexaflow_streak_completed_dates';
  static const String _bestKey = 'nexaflow_streak_best_record';

  String formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Set<String> loadCompletedDates() {
    final list = _storage.getStringList(_datesKey);
    if (list != null && list.isNotEmpty) {
      return list.toSet();
    }
    // Seed initial historical dates for fresh install so user starts with an active streak
    final now = DateTime.now();
    final seeded = <String>{};
    for (int i = 1; i <= 3; i++) {
      seeded.add(formatDate(now.subtract(Duration(days: i))));
    }
    saveCompletedDates(seeded);
    return seeded;
  }

  Future<void> saveCompletedDates(Set<String> dates) async {
    await _storage.setStringList(_datesKey, dates.toList());
  }

  int loadBestRecord() {
    return _storage.getInt(_bestKey) ?? 3;
  }

  Future<void> saveBestRecord(int best) async {
    await _storage.setInt(_bestKey, best);
  }

  StreakInfo calculateStreakInfo(Set<String> completedDates) {
    final now = DateTime.now();
    final todayStr = formatDate(now);
    final isTodayCompleted = completedDates.contains(todayStr);

    // Calculate current streak
    int currentStreak = 0;
    DateTime checkDate;

    if (isTodayCompleted) {
      checkDate = now;
    } else {
      checkDate = now.subtract(const Duration(days: 1));
    }

    while (completedDates.contains(formatDate(checkDate))) {
      currentStreak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    // Update and persist best record
    final savedBest = loadBestRecord();
    final bestStreak = max(savedBest, currentStreak);
    if (bestStreak > savedBest) {
      saveBestRecord(bestStreak);
    }

    // Build rolling last 7 days ending with today
    final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final last7Days = <DayCompletion>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = formatDate(date);
      final isCompleted = completedDates.contains(dateStr);
      final isToday = i == 0;
      final weekdayIndex = date.weekday - 1; // 1 (Mon) -> 0

      last7Days.add(
        DayCompletion(
          date: date,
          dayLabel: dayLabels[weekdayIndex],
          isCompleted: isCompleted,
          isToday: isToday,
        ),
      );
    }

    // Build milestones
    final milestones = [
      StreakMilestone(
        days: 7,
        title: '7-Day Warrior',
        isUnlocked: currentStreak >= 7 || bestStreak >= 7,
        icon: '⚡',
      ),
      StreakMilestone(
        days: 30,
        title: '30-Day Master',
        isUnlocked: currentStreak >= 30 || bestStreak >= 30,
        icon: '🏆',
      ),
      StreakMilestone(
        days: 60,
        title: '60-Day Titan',
        isUnlocked: currentStreak >= 60 || bestStreak >= 60,
        icon: '💎',
      ),
      StreakMilestone(
        days: 100,
        title: 'Centurion Legend',
        isUnlocked: currentStreak >= 100 || bestStreak >= 100,
        icon: '👑',
      ),
    ];

    return StreakInfo(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      isTodayCompleted: isTodayCompleted,
      last7Days: last7Days,
      milestones: milestones,
      completedDates: completedDates,
    );
  }
}
