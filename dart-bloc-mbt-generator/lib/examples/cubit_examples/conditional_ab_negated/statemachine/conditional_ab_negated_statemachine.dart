import 'package:state_machine/state_machine.dart';

// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine constructCondtionalAbNegatedStatemachine() {
  final statemachine = StateMachine('conditional_ab');

  final a = statemachine.newState('a');
  final b = statemachine.newState('b');

  // ignore: unused_local_variable
  Transition ab = statemachine.newTransition('ab', {a}, b);
  // ab.cancelIf(
  // (StateChange stateChange) => stateChange.payload.allowed == false);

  statemachine.start(a);

  return statemachine;
}
