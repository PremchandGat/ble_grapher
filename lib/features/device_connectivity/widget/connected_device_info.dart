import 'package:ble_grapher/features/device_connectivity/bloc/device_connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectedDeviceInfoWidget extends StatelessWidget {
  const ConnectedDeviceInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceConnectivityBloc, DeviceConnectivityState>(
        builder: ((context, state) {
      return !state.isConnected
          ? const ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.devices),
              ),
              title: Text("Offline"),
              subtitle: Text("Device not connected"),
              trailing: Icon(
                Icons.sensors_off_outlined,
                color: Colors.red,
              ),
            )
          : ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.devices),
              ),
              title: const Text("Live"),
              subtitle: Text(state.connectToBLE
                  ? state.connectedDevice.bleDevice?.advName ?? "Unknown"
                  : state.connectedDevice.usbDevice?.deviceName ?? "Unknown"),
              trailing: const Icon(
                Icons.sensors_outlined,
                color: Colors.green,
              ),
            );
    }));
  }
}
