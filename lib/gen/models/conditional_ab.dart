import 'package:simple_state_machine/state_machine.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';

StateMachine constructConditionalAbStatemachine() {
  final statemachine = StateMachine('ConditionalAb');

  // Define states
  final conditionalA = statemachine.newState('conditionalA');
  final conditionalB = statemachine.newState('conditionalB');

  // Define transitions and their conditions
  statemachine.newTransition(
      'goToA', {conditionalA, conditionalB}, conditionalA);
  statemachine.newTransition(
      'goToB', {conditionalA, conditionalB}, conditionalB,
      conditions: {
        'inputTypes': {'allowed': bool},
        'conditionTree': {BinaryExpressionTree(root: Node('allowed'))}
      });

  // Define starting state
  statemachine.start(conditionalA);

  return statemachine;
}
