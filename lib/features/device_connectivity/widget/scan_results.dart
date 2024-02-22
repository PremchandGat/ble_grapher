import 'package:ble_grapher/core/language/language.dart';
import 'package:ble_grapher/features/device_connectivity/bloc/device_connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:usb_serial/usb_serial.dart';

class ScanResultWidget extends StatelessWidget {
  const ScanResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeviceConnectivityBloc, DeviceConnectivityState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMessage)));
            context
                .read<DeviceConnectivityBloc>()
                .add(const UpdateErrorMessage(""));
          }
        },
        builder: (context, state) {
          return ListView(
            children: [
              !state.connectToBLE
                  ? const SizedBox()
                  : ListTile(
                      leading: const Icon(Icons.bluetooth),
                      title: const Text("Bluetooth"),
                      subtitle: const Text("Bluetooth Setting"),
                      trailing: Switch(
                          value: state.isBLEStateON,
                          onChanged: (a) {
                            if (!a) return;
                            context
                                .read<DeviceConnectivityBloc>()
                                .add(TurnOnBluetoothEvent());
                          }),
                    ),
              Text(
                state.errorMessage,
              ),
              if (state.connectToBLE)
                for (ScanResult device in state.bluetoothDevices)
                  if (device.advertisementData.connectable)
                    ListTile(
                      title: Text(device.advertisementData.advName.isEmpty
                          ? "Unknown"
                          : device.advertisementData.advName),
                      subtitle: Text(device.device.remoteId.str),
                      trailing: ElevatedButton(
                        child: const Text(Language.buttonConnect),
                        onPressed: () => context
                            .read<DeviceConnectivityBloc>()
                            .add(
                                ConnectToDeviceEvent(bleDevice: device.device)),
                      ),
                    )
                  else
                    const SizedBox()
              else
                for (UsbDevice device in state.devices)
                  ListTile(
                    title: Text(
                        "${device.manufacturerName} ${device.productName}"),
                    subtitle: Text(device.deviceName),
                    trailing: ElevatedButton(
                      child: const Text(Language.buttonConnect),
                      onPressed: () => context
                          .read<DeviceConnectivityBloc>()
                          .add(ConnectToDeviceEvent(usbDevice: device)),
                    ),
                  ),
            ],
          );
        });
  }
}
