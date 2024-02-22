import 'package:ble_grapher/features/chat/model/chat_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState(messages: [])) {
    on<AddNewMessageChatEvent>(_addMessage);
  }
  _addMessage(AddNewMessageChatEvent event, Emitter<ChatState> emit) {
    emit(state.addMessages(event.msg));
  }
}
