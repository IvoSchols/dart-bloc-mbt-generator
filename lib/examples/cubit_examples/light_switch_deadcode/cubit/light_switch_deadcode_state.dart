part of 'light_switch_deadcode_cubit.dart';

abstract class LightSwitchDeadcodeState extends Equatable {
  const LightSwitchDeadcodeState();

  @override
  List<Object> get props => [];
}

class On extends LightSwitchDeadcodeState {}

class Off extends LightSwitchDeadcodeState {}
