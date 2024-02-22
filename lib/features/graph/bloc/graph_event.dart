part of 'graph_bloc.dart';

sealed class GraphEvent extends Equatable {
  const GraphEvent();

  @override
  List<Object> get props => [];
}

class NewDataReceivedEvent extends GraphEvent {
  final String msg;
  final int messageCount;
  const NewDataReceivedEvent(this.msg, this.messageCount);
}

class UpdateXAxisLimitEvent extends GraphEvent {
  final int xAxisLimit;
  const UpdateXAxisLimitEvent(this.xAxisLimit);
}

class UpdateGraphSizeEvent extends GraphEvent {
  final double? height;
  final double? width;
  const UpdateGraphSizeEvent({this.height, this.width});
}
