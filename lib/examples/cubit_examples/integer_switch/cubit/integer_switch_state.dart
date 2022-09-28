part of 'integer_switch_cubit.dart';

abstract class IntegerSwitchState extends Equatable {
  const IntegerSwitchState();

  @override
  List<Object> get props => [];
}

class Zero extends IntegerSwitchState {}

class Minus20 extends IntegerSwitchState {}

class FourtySeven extends IntegerSwitchState {}
