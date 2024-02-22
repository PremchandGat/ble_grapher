import 'package:ble_grapher/features/device_connectivity/bloc/device_connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageSendWidget extends StatefulWidget {
  const MessageSendWidget({super.key});

  @override
  State<MessageSendWidget> createState() => _MessageSendWidgetState();
}

class _MessageSendWidgetState extends State<MessageSendWidget> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (a) => setState(() {}),
        controller: textEditingController,
        maxLines: null,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(4))),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).highlightColor, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton.filled(
                onPressed: textEditingController.text.isEmpty
                    ? null
                    : () {
                        context
                            .read<DeviceConnectivityBloc>()
                            .add(SendDataEvent(textEditingController.text));
                        textEditingController.clear();
                      },
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                )),
          ),
          hintText: 'message',
        ),
      ),
    );
  }
}
