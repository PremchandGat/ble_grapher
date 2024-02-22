part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class AddNewMessageChatEvent extends ChatEvent {
  final ChatMessage msg;
  const AddNewMessageChatEvent(this.msg);
  @override
  List<Object> get props => [msg];
}
