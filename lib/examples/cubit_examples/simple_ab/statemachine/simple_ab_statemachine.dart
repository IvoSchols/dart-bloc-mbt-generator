import 'package:state_machine/state_machine.dart';

// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine constructSimpleAbStatemachine() {
  final statemachine = StateMachine('simple_ab');

  final a = statemachine.newState('a');
  final b = statemachine.newState('b');

  // ignore: unused_local_variable
  Transition ab = statemachine.newStateTransition('ab', [a], b);

  statemachine.start(a);

  return statemachine;
}
