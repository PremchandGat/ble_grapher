import 'package:ble_grapher/features/chat/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bubble.dart';

class ChatMessagesWidget extends StatelessWidget {
  ChatMessagesWidget({super.key});
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(listener: (context, state) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent +
            MediaQuery.of(context).size.height,
        duration: const Duration(milliseconds: 10),
        curve: Curves.linear,
      );
    }, builder: (context, state) {
      return ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 12, bottom: 20) +
              const EdgeInsets.symmetric(horizontal: 12),
          separatorBuilder: (_, __) => const SizedBox(
                height: 12,
              ),
          controller: _scrollController,
          itemCount: state.messages.length,
          itemBuilder: (context, index) {
            return Bubble(chat: state.messages[index]);
          });
    });
  }
}
