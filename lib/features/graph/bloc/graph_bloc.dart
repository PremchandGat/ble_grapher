import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';

part 'graph_event.dart';
part 'graph_state.dart';

class GraphBloc extends Bloc<GraphEvent, GraphState> {
  GraphBloc() : super(const GraphState()) {
    on<NewDataReceivedEvent>(onDataReceived);
    on<UpdateXAxisLimitEvent>(_updateXAxisLimit);
    on<UpdateGraphSizeEvent>(_updateGraphSize);
  }

  _updateGraphSize(UpdateGraphSizeEvent event, Emitter<GraphState> emit) {
    emit(state.copyWith(graphHeight: event.height));
  }

  _updateXAxisLimit(UpdateXAxisLimitEvent event, Emitter<GraphState> emit) {
    emit(state.copyWith(xAxisSize: event.xAxisLimit));
  }

  onDataReceived(NewDataReceivedEvent event, Emitter<GraphState> emit) {
    try {
      List<String> data = event.msg.split(',');
      List<List<FlSpot>> finalData = [];
      for (int column = 0; column < data.length; column++) {
        finalData.add(
            List.of(state.data.length > column ? state.data[column] : [])
              ..add(FlSpot(
                  event.messageCount.toDouble(), double.parse(data[column]))));
        while (finalData[column].length > state.xAxisSize) {
          finalData[column].removeAt(0);
        }
      }
      emit(state.copyWith(data: finalData));
    } catch (e) {
      print("Error: $e");
    }
  }
}
