part of 'traffic_light_cubit.dart';

abstract class TrafficLightState extends Equatable {
  const TrafficLightState();

  @override
  List<Object> get props => [];
}

class Green extends TrafficLightState {}

class Yellow extends TrafficLightState {}

class Red extends TrafficLightState {}
