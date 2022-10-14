import 'package:simple_state_machine/state_machine.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';

StateMachine constructConditionalAbStatemachine() {
  final statemachine = StateMachine('ConditionalAb');

  // Define states
  final ConditionalA = statemachine.newState('ConditionalA');
  final ConditionalB = statemachine.newState('ConditionalB');

  // Define transitions and their conditions
  Transition ConditionalAConditionalBgoToAConditionalA = statemachine
      .newTransition('goToA', {ConditionalA, ConditionalB}, ConditionalA);
  Transition ConditionalAConditionalBgoToBConditionalB = statemachine
      .newTransition('goToB', {ConditionalA, ConditionalB}, ConditionalB,
          conditions: {
            'inputTypes': {'allowed': bool},
            'conditionTree': {BinaryExpressionTree(root: Node('allowed'))}
          });

  // Define starting state
  statemachine.start(ConditionalA);

  return statemachine;
}
