import 'FiniteStateMachineBase.dart';

abstract class FiniteStateMachine {
  State transition(State state, String event);
  void export(String path);
  FiniteStateMachine import(String path);
}
