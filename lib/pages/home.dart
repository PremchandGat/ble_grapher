import 'package:ble_grapher/core/language/language.dart';
import 'package:ble_grapher/features/device_connectivity/bloc/device_connectivity_bloc.dart';
import 'package:ble_grapher/features/device_connectivity/widget/connected_device_info.dart';
import 'package:ble_grapher/features/graph/widget/data_xaxis_limit_slider_widget.dart';
import 'package:ble_grapher/features/graph/widget/graph_size_adjuster_widget.dart';
import 'package:ble_grapher/pages/chat.dart';
import 'package:ble_grapher/pages/discover_devices.dart';
import 'package:ble_grapher/pages/graph_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceConnectivityBloc, DeviceConnectivityState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(Language.appName),
          ),
          drawer: Drawer(
            child: SafeArea(
              child: ListView(
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    child: const ListTile(
                      leading: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Menu",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => const DiscoverDevices())),
                    title: const Text("Discover Devices"),
                    subtitle: const Text("Search and connect to device"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => const ChatPage())),
                    title: const Text("Chat"),
                    subtitle: const Text("Chat with device"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  )
                ],
              ),
            ),
          ),
          body: ListView(
            children: const [
              ConnectedDeviceInfoWidget(),
              GraphPage(),
              XAxisDataSliderWidget(),
              GraphSizeAdjustmentWidget()
            ],
          ),
        ));
  }
}
