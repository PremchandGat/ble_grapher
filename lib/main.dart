import 'package:ble_grapher/features/device_connectivity/bloc/device_connectivity_bloc.dart';
import 'package:ble_grapher/features/graph/bloc/graph_bloc.dart';
import 'package:ble_grapher/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<DeviceConnectivityBloc>(
            create: (BuildContext context) =>
                DeviceConnectivityBloc()..add(ListenToBluetoothAdapterEvent()),
          ),
          BlocProvider<GraphBloc>(
            create: (BuildContext context) => GraphBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'BLE(USB) Grapher(Terminal)',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomePage(),
        ));
  }
}
