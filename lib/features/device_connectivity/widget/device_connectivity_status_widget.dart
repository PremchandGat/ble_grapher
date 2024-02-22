import 'package:ble_grapher/features/device_connectivity/bloc/device_connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeviceConnectivityStatusWidget extends StatelessWidget {
  const DeviceConnectivityStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceConnectivityBloc, DeviceConnectivityState>(
        builder: (context, state) {
      return Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: state.isConnected ? Colors.green : Colors.red),
          child: Text(
            state.isConnected ? "Device connected" : "Device not connected",
            textAlign: TextAlign.center,
          ));
    });
  }
}
