// @dart=2.9
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
import 'package:state_machine/state_machine.dart';

// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine constructSimpleAbStatemachine() {
  final statemachine = StateMachine('SimpleAb');

  // Define states
  final SimpleA = statemachine.newState('SimpleA');
  final SimpleB = statemachine.newState('SimpleB');

  // Define transitions and their conditions
  StateTransition goToA =
      statemachine.newStateTransition('goToA', [SimpleA, SimpleB], SimpleA);

  StateTransition goToB =
      statemachine.newStateTransition('goToB', [SimpleA, SimpleB], SimpleB);

  // Define starting state
  statemachine.start(SimpleA);

  return statemachine;
}
