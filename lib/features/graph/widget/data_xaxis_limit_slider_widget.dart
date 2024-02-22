import 'package:ble_grapher/features/graph/bloc/graph_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class XAxisDataSliderWidget extends StatelessWidget {
  const XAxisDataSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraphBloc, GraphState>(
        buildWhen: (previous, current) =>
            previous.xAxisSize != current.xAxisSize,
        builder: ((context, state) {
          return ListTile(
            title: Text("X Axis Size (${state.xAxisSize})"),
            subtitle: Slider(
                min: 10,
                max: 2000,
                value: state.xAxisSize.toDouble(),
                onChanged: (double val) => context
                    .read<GraphBloc>()
                    .add(UpdateXAxisLimitEvent(val.toInt()))),
          );
        }));
  }
}
