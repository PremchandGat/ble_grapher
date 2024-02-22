part of 'graph_bloc.dart';

class GraphState extends Equatable {
  final int xAxisSize;
  final int limitGraphs;
  final List<List<FlSpot>> data;
  final double graphHeight;

  const GraphState(
      {this.xAxisSize = 100,
      this.data = const [],
      this.limitGraphs = -1,
      this.graphHeight = 500});

  GraphState copyWith({
    double? graphHeight,
    int? xAxisSize,
    int? limitGraphs,
    List<List<FlSpot>>? data,
  }) {
    return GraphState(
        graphHeight: graphHeight ?? this.graphHeight,
        xAxisSize: xAxisSize ?? this.xAxisSize,
        limitGraphs: limitGraphs ?? this.xAxisSize,
        data: data ?? this.data);
  }

  @override
  List<Object> get props => [xAxisSize, limitGraphs, data, graphHeight];
}
