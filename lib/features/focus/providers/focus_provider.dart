import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/storage_service.dart';
import '../models/focus_session.dart';
import '../services/focus_notification_service.dart';

class FocusNotifier extends StateNotifier<FocusSession> {
  FocusNotifier(this._storage, this._notificationService)
      : super(
          FocusSession(
            duration: const Duration(minutes: 25),
            remaining: const Duration(minutes: 25),
            isRunning: false,
            completedSessions: _loadCompletedSessions(_storage),
          ),
        );

  final StorageService _storage;
  final FocusNotificationService _notificationService;
  static const String _storageKey = 'nexaflow_focus_sessions_today';
  static const String _dateKey = 'nexaflow_focus_last_date';

  static int _loadCompletedSessions(StorageService storage) {
    final lastDateStr = storage.getString(_dateKey);
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';

    if (lastDateStr == todayStr) {
      return storage.getInt(_storageKey) ?? 0;
    } else {
      storage.setString(_dateKey, todayStr);
      storage.setInt(_storageKey, 0);
      return 0;
    }
  }

  void _persistCompletedSessions(int count) {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';
    _storage.setString(_dateKey, todayStr);
    _storage.setInt(_storageKey, count);
  }

  Timer? _timer;

  void start() {
    if (state.isRunning) return;

    state = state.copyWith(isRunning: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remaining.inSeconds <= 1) {
        _timer?.cancel();

        final newCompleted = state.completedSessions + 1;
        _persistCompletedSessions(newCompleted);
        _notificationService.notifySessionCompleted(state.duration.inMinutes);

        state = state.copyWith(
          isRunning: false,
          remaining: state.duration,
          completedSessions: newCompleted,
        );

        return;
      }

      state = state.copyWith(
        remaining: state.remaining - const Duration(seconds: 1),
      );
    });
  }

  void pause() {
    _timer?.cancel();

    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();

    state = state.copyWith(isRunning: false, remaining: state.duration);
  }

  void setDuration(Duration duration) {
    _timer?.cancel();
    state = state.copyWith(
      duration: duration,
      remaining: duration,
      isRunning: false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final focusProvider = StateNotifierProvider<FocusNotifier, FocusSession>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final notificationService = ref.watch(focusNotificationServiceProvider);
  return FocusNotifier(storage, notificationService);
});


