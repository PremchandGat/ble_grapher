import 'package:ble_grapher/features/device_connectivity/bloc/device_connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LastMessageWidget extends StatelessWidget {
  const LastMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: const Text("Last Message"),
        subtitle: BlocBuilder<DeviceConnectivityBloc, DeviceConnectivityState>(
            builder: (context, state) {
          return Text(state.lastMessage);
        }));
  }
}
