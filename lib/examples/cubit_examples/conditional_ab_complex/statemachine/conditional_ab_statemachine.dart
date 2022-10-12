import 'package:simple_state_machine/state_machine.dart';

// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine constructCondtionalAbStatemachine() {
  final statemachine = StateMachine('conditional_ab');

  final a = statemachine.newState('a');
  final b = statemachine.newState('b');

  // ignore: unused_local_variable
  Transition ab = statemachine.newTransition('ab', {a}, b);

  statemachine.start(a);

  return statemachine;
}
