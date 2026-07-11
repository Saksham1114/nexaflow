enum MessageType { user, assistant }

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.message,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String message;
  final MessageType type;
  final DateTime createdAt;
}
