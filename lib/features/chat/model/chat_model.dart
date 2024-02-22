enum ChatMessageType {
  sent,
  received,
}

class ChatMessage {
  final String message;
  final ChatMessageType type;
  final DateTime? time;
  final bool isSuccess;

  const ChatMessage(
      {required this.message,
      required this.type,
      required this.time,
      this.isSuccess = true});

  factory ChatMessage.sent({required message, bool isSuccess = true}) =>
      ChatMessage(
          isSuccess: isSuccess,
          message: message,
          type: ChatMessageType.sent,
          time: DateTime.now());

  factory ChatMessage.received({required message}) => ChatMessage(
      message: message, type: ChatMessageType.received, time: DateTime.now());
}

class EmptyChatMessage extends ChatMessage {
  const EmptyChatMessage({super.message = "", required super.type, super.time});
}
