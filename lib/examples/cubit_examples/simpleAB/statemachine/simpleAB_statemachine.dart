import 'package:state_machine/state_machine.dart';

// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine constructSimpleABStatemachine() {
  final statemachine = StateMachine('simpleAB');

  final a = statemachine.newState('a');
  final b = statemachine.newState('b');

  StateTransition ab = statemachine.newStateTransition('ab', [a], b);

  statemachine.start(a);

  return statemachine;
}
