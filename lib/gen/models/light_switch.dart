import 'package:simple_state_machine/state_machine.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';

StateMachine constructLightSwitchStatemachine() {
  final statemachine = StateMachine('LightSwitch');

  // Define states
  final off = statemachine.newState('off');
  final on = statemachine.newState('on');

  // Define transitions and their conditions
  Transition lightSwitchon =
      statemachine.newTransition('lightSwitch', {off, on}, on,
          conditions: {
            'inputTypes': {'on': bool},
            'conditionTree': {BinaryExpressionTree(root: Node('on'))}
          });
  Transition lightSwitchoff =
      statemachine.newTransition('lightSwitch', {off, on}, off,
          conditions: {
            'inputTypes': {'on': bool},
            'conditionTree': {
              BinaryExpressionTree(root: Node('!', left: Node('on')))
            }
          });

  // Define starting state
  statemachine.start(off);

  return statemachine;
}
