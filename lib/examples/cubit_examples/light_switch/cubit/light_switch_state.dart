part of 'light_switch_cubit.dart';

abstract class LightSwitchState extends Equatable {
  const LightSwitchState();

  @override
  List<Object> get props => [];
}

class On extends LightSwitchState {}

class Off extends LightSwitchState {}
