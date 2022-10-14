import 'package:simple_state_machine/state_machine.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';

StateMachine constructLightSwitchDeadcodeStatemachine() {
  final statemachine = StateMachine('LightSwitchDeadcode');

  // Define states
  final off = statemachine.newState('off');
  final on = statemachine.newState('on');
  final exception = statemachine.newState('exception');

  // Define transitions and their conditions
  statemachine.newTransition('lightSwitch', {off, on, exception}, on,
      conditions: {
        'inputTypes': {'on': bool},
        'conditionTree': {BinaryExpressionTree(root: Node('on'))}
      });
  statemachine.newTransition('lightSwitch', {off, on, exception}, off,
      conditions: {
        'inputTypes': {'on': bool},
        'conditionTree': {
          BinaryExpressionTree(root: Node('!', left: Node('on')))
        }
      });
  statemachine.newTransition('lightSwitch', {off, on, exception}, exception,
      conditions: {
        'inputTypes': {'on': bool},
        'conditionTree': {
          BinaryExpressionTree(
              root: Node('&&',
                  left: Node('!', left: Node('on')), right: Node('on')))
        }
      });

  // Define starting state
  statemachine.start(off);

  return statemachine;
}
