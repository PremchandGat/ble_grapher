import 'package:ble_grapher/features/device_connectivity/bloc/device_connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharBleUUIDWidget extends StatefulWidget {
  const CharBleUUIDWidget({super.key});

  @override
  State<CharBleUUIDWidget> createState() => _CharBleUUIDWidgetState();
}

class _CharBleUUIDWidgetState extends State<CharBleUUIDWidget> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceConnectivityBloc, DeviceConnectivityState>(
      buildWhen: (previous, current) =>
          previous.bleCharUUID != current.bleCharUUID,
      builder: (context, state) {
        return Column(
          children: [
            const Text(
              'BLE Settings',
              style: TextStyle(fontSize: 18),
            ),
            ListTile(
              title: const Text("BLE Charctristic UUID to Connect"),
              subtitle: Text(state.bleCharUUID),
            ),
            TextField(
              controller: textEditingController,
              onChanged: (a) => setState(() {}),
              decoration: InputDecoration(
                hintText: state.bleCharUUID,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).highlightColor, width: 3),
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
              ),
            ),
            FilledButton(
                onPressed: textEditingController.text.isEmpty ? null : () {},
                child: const Text("Update Char UUID"))
          ],
        );
      },
    );
  }
}
