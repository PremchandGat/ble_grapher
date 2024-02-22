import 'package:ble_grapher/features/device_connectivity/bloc/device_connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshDevicesButtonWidget extends StatelessWidget {
  const RefreshDevicesButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () =>
          context.read<DeviceConnectivityBloc>().add(RefreshDevicesEvent()),
      icon: const Icon(Icons.refresh),
      // label: const Text(Language.buttonRefresh)
    );
  }
}
