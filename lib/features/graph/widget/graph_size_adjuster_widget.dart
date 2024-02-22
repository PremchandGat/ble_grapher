import 'package:ble_grapher/features/graph/bloc/graph_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GraphSizeAdjustmentWidget extends StatelessWidget {
  const GraphSizeAdjustmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraphBloc, GraphState>(
        buildWhen: (previous, current) =>
            previous.graphHeight != current.graphHeight,
        builder: ((context, state) {
          return Column(
            children: [
              ListTile(
                title: Text("Graph Height (${state.graphHeight})"),
                subtitle: Slider(
                    min: 100,
                    max: state.graphHeight > MediaQuery.of(context).size.height
                        ? state.graphHeight
                        : MediaQuery.of(context).size.height,
                    value: state.graphHeight,
                    onChanged: (double val) => context
                        .read<GraphBloc>()
                        .add(UpdateGraphSizeEvent(height: val))),
              ),
            ],
          );
        }));
  }
}
