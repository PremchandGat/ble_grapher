import 'package:ble_grapher/features/device_connectivity/widget/ble_usb_option_Widget.dart';
import 'package:ble_grapher/features/device_connectivity/widget/device_connectivity_status_widget.dart';
import 'package:ble_grapher/features/device_connectivity/widget/refresh_devices_button_widget.dart';
import 'package:ble_grapher/features/device_connectivity/widget/scan_results.dart';
import 'package:flutter/material.dart';

class DiscoverDevices extends StatelessWidget {
  const DiscoverDevices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover Devices"),
        actions: const [RefreshDevicesButtonWidget()],
        bottom: PreferredSize(
            preferredSize: Size(
                double.infinity, MediaQuery.of(context).size.height * 0.05),
            child: const BleUsbOptiuonWidget()),
      ),
      body: const ScanResultWidget(),
      bottomSheet: const DeviceConnectivityStatusWidget(),
    );
  }
}
