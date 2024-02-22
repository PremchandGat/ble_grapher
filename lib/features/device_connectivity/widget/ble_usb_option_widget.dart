import 'package:ble_grapher/features/device_connectivity/bloc/device_connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BleUsbOptiuonWidget extends StatelessWidget {
  const BleUsbOptiuonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: BlocBuilder<DeviceConnectivityBloc, DeviceConnectivityState>(
          builder: (context, state) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChoiceChip(
                      onSelected: (a) => context
                          .read<DeviceConnectivityBloc>()
                          .add(ChooseBLEorUSBDeviceConnectivityEvent(a)),
                      label: const Text("Bluetooth"),
                      selected: state.connectToBLE),
                  const SizedBox(
                    width: 100,
                  ),
                  ChoiceChip(
                      onSelected: (a) => context
                          .read<DeviceConnectivityBloc>()
                          .add(ChooseBLEorUSBDeviceConnectivityEvent(!a)),
                      label: const Text("USB"),
                      selected: !state.connectToBLE),
                ],
              )),
    );
  }
}
