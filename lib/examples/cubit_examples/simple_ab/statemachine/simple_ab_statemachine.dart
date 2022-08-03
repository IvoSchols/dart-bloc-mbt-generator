import 'package:state_machine/state_machine.dart';

// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine constructSimpleABStatemachine() {
  final statemachine = StateMachine('simple_ab');

  final a = statemachine.newState('a');
  final b = statemachine.newState('b');

  StateTransition ab = statemachine.newStateTransition('ab', [a], b);
  ab.cancelIf((stateChange) => false);

  statemachine.start(a);

  return statemachine;
}
