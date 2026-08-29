import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/focus_session.dart';

class FocusNotifier extends StateNotifier<FocusSession> {
  FocusNotifier()
    : super(
        const FocusSession(
          duration: Duration(minutes: 25),
          remaining: Duration(minutes: 25),
          isRunning: false,
          completedSessions: 0,
        ),
      );

  Timer? _timer;

  void start() {
    if (state.isRunning) return;

    state = state.copyWith(isRunning: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remaining.inSeconds <= 1) {
        _timer?.cancel();

        state = state.copyWith(
          isRunning: false,
          remaining: state.duration,
          completedSessions: state.completedSessions + 1,
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final focusProvider = StateNotifierProvider<FocusNotifier, FocusSession>(
  (ref) => FocusNotifier(),
);
