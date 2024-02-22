part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  const ChatState({
    required this.messages,
  });

  ChatState addMessages(ChatMessage msg) {
    if (messages.length > 1000) {
      return ChatState(
          messages: List.of(messages)
            ..add(msg)
            ..removeAt(0));
    }
    return ChatState(messages: List.of(messages)..add(msg));
  }

  @override
  List<Object> get props => [messages];
}
