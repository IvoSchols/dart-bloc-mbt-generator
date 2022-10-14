import 'package:simple_state_machine/state_machine.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';

StateMachine constructTrafficLightStatemachine() {
  final statemachine = StateMachine('TrafficLight');

  // Define states
  final red = statemachine.newState('red');
  final green = statemachine.newState('green');
  final yellow = statemachine.newState('yellow');
  final exception = statemachine.newState('exception');

  // Define transitions and their conditions
  statemachine.newTransition(
      'changeTrafficLightTo', {red, green, yellow, exception}, red,
      conditions: {
        'inputTypes': {'color': String},
        'conditionTree': {
          BinaryExpressionTree(
              root: Node('==', left: Node('color'), right: Node('red')))
        }
      });
  statemachine.newTransition(
      'changeTrafficLightTo', {red, green, yellow, exception}, green,
      conditions: {
        'inputTypes': {'color': String},
        'conditionTree': {
          BinaryExpressionTree(
              root: Node('==', left: Node('color'), right: Node('green')))
        }
      });
  statemachine.newTransition(
      'changeTrafficLightTo', {red, green, yellow, exception}, yellow,
      conditions: {
        'inputTypes': {'color': String},
        'conditionTree': {
          BinaryExpressionTree(
              root: Node('==', left: Node('color'), right: Node('yellow')))
        }
      });
  statemachine.newTransition(
      'changeTrafficLightTo', {red, green, yellow, exception}, exception,
      conditions: {
        'inputTypes': {'color': String},
        'conditionTree': {
          BinaryExpressionTree(
              root: Node('&&',
                  left: Node('&&',
                      left: Node('!=', left: Node('color'), right: Node('red')),
                      right: Node('!=',
                          left: Node('color'), right: Node('green'))),
                  right:
                      Node('!=', left: Node('color'), right: Node('yellow'))))
        }
      });

  // Define starting state
  statemachine.start(red);

  return statemachine;
}
