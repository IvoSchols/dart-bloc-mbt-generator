import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'traffic_light_state.dart';

class TrafficLightCubit extends Cubit<TrafficLightState> {
  TrafficLightCubit() : super(Red());

  void changeTrafficLightTo(String color) {
    switch (color) {
      case 'red':
        emit(Red());
        break;
      case 'green':
        emit(Green());
        break;
      case 'yellow':
        emit(Yellow());
        break;
      default:
        throw Exception('Invalid state');
    }
  }
}
