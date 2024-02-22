import 'package:ble_grapher/features/device_connectivity/bloc/device_connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageCountWidget extends StatelessWidget {
  const MessageCountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceConnectivityBloc, DeviceConnectivityState>(
        builder: (context, state) => GestureDetector(
              onTap: () => context
                  .read<DeviceConnectivityBloc>()
                  .add(ClearMessageCountEvent()),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.message,
                        color: Theme.of(context).disabledColor,
                      ),
                      Text(
                        state.messageCount.toString(),
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
