import 'package:ble_grapher/features/device_connectivity/bloc/device_connectivity_bloc.dart';
import 'package:ble_grapher/features/graph/bloc/graph_bloc.dart';
import 'package:ble_grapher/features/graph/widget/graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceConnectivityBloc, DeviceConnectivityState>(
      listenWhen: (previous, current) =>
          previous.messageCount != current.messageCount,
      listener: (context, state) {
        context
            .read<GraphBloc>()
            .add(NewDataReceivedEvent(state.lastMessage, state.messageCount));
      },
      child: GraphWidget(),
    );
  }
}
