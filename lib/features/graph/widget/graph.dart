import 'package:ble_grapher/features/graph/bloc/graph_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GraphWidget extends StatelessWidget {
  const GraphWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraphBloc, GraphState>(
      builder: (context, state) {
        return SizedBox(
          height: state.graphHeight,
          child: LineChart(
            LineChartData(
                lineBarsData: [
                  for (List<FlSpot> data in state.data)
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      barWidth: 2,
                      dotData: const FlDotData(
                        show: false,
                      ),
                    ),
                ],
                titlesData: const FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                )),
          ),
        );
      },
    );
  }
}
