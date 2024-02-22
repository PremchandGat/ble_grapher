import 'package:ble_grapher/features/chat/bloc/chat_bloc.dart';
import 'package:ble_grapher/features/chat/model/chat_model.dart';
import 'package:ble_grapher/features/chat/widgets/chat_messages_widget.dart';
import 'package:ble_grapher/features/device_connectivity/bloc/device_connectivity_bloc.dart';
import 'package:ble_grapher/features/device_connectivity/widget/message_count_widget.dart';
import 'package:ble_grapher/features/device_connectivity/widget/send_data_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
      child: BlocListener<DeviceConnectivityBloc, DeviceConnectivityState>(
        listenWhen: (previous, current) =>
            previous.lasMessageSent != current.lasMessageSent,
        listener: (context, state) {
          context
              .read<ChatBloc>()
              .add(AddNewMessageChatEvent(state.lasMessageSent));
        },
        child: BlocListener<DeviceConnectivityBloc, DeviceConnectivityState>(
          listenWhen: (previous, current) =>
              previous.messageCount != current.messageCount,
          listener: (context, state) {
            context.read<ChatBloc>().add(AddNewMessageChatEvent(
                ChatMessage.received(message: state.lastMessage)));
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Row(
                children: [
                  const Text("Chat"),
                  context.watch<DeviceConnectivityBloc>().state.isConnected
                      ? const Text(
                          "(Live)",
                          style: TextStyle(color: Colors.green),
                        )
                      : const Text(
                          "(Offline)",
                          style: TextStyle(color: Colors.red),
                        )
                ],
              ),
              actions: const [MessageCountWidget()],
            ),
            body: Column(
              children: [
                Expanded(child: ChatMessagesWidget()),
                const MessageSendWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
