import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/streak_provider.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import '../../focus/providers/focus_provider.dart';
import '../../habits/providers/habit_provider.dart';
import '../../settings/providers/settings_provider.dart';
import '../../tasks/providers/task_provider.dart';
import '../../water/providers/water_provider.dart';
import '../models/chat_message.dart';
import '../services/ai_assistant_service.dart';

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier(this._aiService, this._ref)
      : super([
          ChatMessage(
            id: 'welcome_msg',
            message:
                "👋 **Hi! I'm Nexa AI**, your personal productivity copilot.\n\n"
                "I analyze your tasks, habits, hydration, and streaks in real-time.\n"
                "Ask me anything, or tap a quick prompt below to get started!",
            type: MessageType.assistant,
            createdAt: DateTime.now(),
          ),
        ]);

  final AIAssistantService _aiService;
  final Ref _ref;

  Future<void> sendMessage(String text) async {
    final userMsg = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      message: text,
      type: MessageType.user,
      createdAt: DateTime.now(),
    );

    state = [...state, userMsg];

    final tasks = _ref.read(taskProvider);
    final habits = _ref.read(habitProvider);
    final waterEntries = _ref.read(waterProvider);
    final settings = _ref.read(settingsProvider);
    final streak = _ref.read(streakProvider);
    final focus = _ref.read(focusProvider);
    final overview = _ref.read(dashboardProvider);

    await Future.delayed(const Duration(milliseconds: 200));

    final reply = _aiService.answerUserQuery(
      prompt: text,
      tasks: tasks,
      habits: habits,
      waterEntries: waterEntries,
      waterGoal: settings.dailyGoal,
      currentStreak: streak.currentStreak,
      bestStreak: streak.bestStreak,
      focusMinutes: focus.completedSessions * focus.duration.inMinutes,
      overview: overview,
    );

    final assistantMsg = ChatMessage(
      id: (DateTime.now().microsecondsSinceEpoch + 1).toString(),
      message: reply,
      type: MessageType.assistant,
      createdAt: DateTime.now(),
    );

    state = [...state, assistantMsg];
  }

  void clearChat() {
    state = [
      ChatMessage(
        id: 'welcome_reset',
        message:
            "💬 **Chat cleared.** How can I help optimize your productivity today?",
        type: MessageType.assistant,
        createdAt: DateTime.now(),
      ),
    ];
  }
}

final chatProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  final aiService = ref.watch(aiAssistantServiceProvider);
  return ChatNotifier(aiService, ref);
});

