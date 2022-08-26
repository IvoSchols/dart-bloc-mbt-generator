// @dart=2.9
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
import 'package:state_machine/state_machine.dart';

// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine constructConditionalAbStatemachine() {
  final statemachine = StateMachine('ConditionalAb');

  // Define states
  final ConditionalA = statemachine.newState('ConditionalA');
  final ConditionalB = statemachine.newState('ConditionalB');

  // Define transitions and their conditions
  StateTransition goToA = statemachine.newStateTransition(
      'goToA', [ConditionalA, ConditionalB], ConditionalA);

  StateTransition goToB = statemachine.newStateTransition(
      'goToB', [ConditionalA, ConditionalB], ConditionalB);

  goToB.cancelIf((StateChange change) => !change.payload.allowed);

  // Define starting state
  statemachine.start(ConditionalA);

  return statemachine;
}
