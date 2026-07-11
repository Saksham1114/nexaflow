import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_message.dart';

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super(const []);

  void sendUserMessage(String text) {
    state = [
      ...state,
      ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        message: text,
        type: MessageType.user,
        createdAt: DateTime.now(),
      ),
    ];
  }

  void sendAssistantMessage(String text) {
    state = [
      ...state,
      ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        message: text,
        type: MessageType.assistant,
        createdAt: DateTime.now(),
      ),
    ];
  }

  void clearChat() {
    state = [];
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>(
  (ref) => ChatNotifier(),
);
