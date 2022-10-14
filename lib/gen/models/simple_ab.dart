import 'package:simple_state_machine/state_machine.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';

StateMachine constructSimpleAbStatemachine() {
  final statemachine = StateMachine('SimpleAb');

  // Define states
  final simpleA = statemachine.newState('simpleA');
  final simpleB = statemachine.newState('simpleB');

  // Define transitions and their conditions
  Transition goToAsimpleA =
      statemachine.newTransition('goToA', {simpleA, simpleB}, simpleA);
  Transition goToBsimpleB =
      statemachine.newTransition('goToB', {simpleA, simpleB}, simpleB);

  // Define starting state
  statemachine.start(simpleA);

  return statemachine;
}
