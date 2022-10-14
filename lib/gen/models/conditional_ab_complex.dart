import 'package:simple_state_machine/state_machine.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';

StateMachine constructConditionalAbComplexStatemachine() {
  final statemachine = StateMachine('ConditionalAbComplex');

  // Define states
  final conditionalA = statemachine.newState('conditionalA');
  final conditionalBool = statemachine.newState('conditionalBool');
  final conditional0 = statemachine.newState('conditional0');
  final conditional3 = statemachine.newState('conditional3');
  final conditionalMinus12 = statemachine.newState('conditionalMinus12');
  final conditionalMinus7 = statemachine.newState('conditionalMinus7');
  final conditionalMinus9 = statemachine.newState('conditionalMinus9');
  final conditionalMinus8 = statemachine.newState('conditionalMinus8');
  final conditionalStringFoo = statemachine.newState('conditionalStringFoo');
  final conditionalStringBar = statemachine.newState('conditionalStringBar');

  // Define transitions and their conditions
  Transition goToAconditionalA = statemachine.newTransition(
      'goToA',
      {
        conditionalA,
        conditionalBool,
        conditional0,
        conditional3,
        conditionalMinus12,
        conditionalMinus7,
        conditionalMinus9,
        conditionalMinus8,
        conditionalStringFoo,
        conditionalStringBar
      },
      conditionalA);
  Transition goToBoolconditionalBool = statemachine.newTransition(
      'goToBool',
      {
        conditionalA,
        conditionalBool,
        conditional0,
        conditional3,
        conditionalMinus12,
        conditionalMinus7,
        conditionalMinus9,
        conditionalMinus8,
        conditionalStringFoo,
        conditionalStringBar
      },
      conditionalBool,
      conditions: {
        'inputTypes': {'allowed': bool},
        'conditionTree': {BinaryExpressionTree(root: Node('allowed'))}
      });
  Transition goToBoolconditionalA = statemachine.newTransition(
      'goToBool',
      {
        conditionalA,
        conditionalBool,
        conditional0,
        conditional3,
        conditionalMinus12,
        conditionalMinus7,
        conditionalMinus9,
        conditionalMinus8,
        conditionalStringFoo,
        conditionalStringBar
      },
      conditionalA,
      conditions: {
        'inputTypes': {'allowed': bool},
        'conditionTree': {
          BinaryExpressionTree(
              root: Node('&&',
                  left: Node('!', left: Node('allowed')),
                  right: Node('!', left: Node('allowed'))))
        }
      });
  Transition goToIntconditional0 = statemachine.newTransition(
      'goToInt',
      {
        conditionalA,
        conditionalBool,
        conditional0,
        conditional3,
        conditionalMinus12,
        conditionalMinus7,
        conditionalMinus9,
        conditionalMinus8,
        conditionalStringFoo,
        conditionalStringBar
      },
      conditional0,
      conditions: {
        'inputTypes': {'value': int},
        'conditionTree': {
          BinaryExpressionTree(
              root: Node('==', left: Node('value'), right: Node('0')))
        }
      });
  Transition goToIntconditional3 = statemachine.newTransition(
      'goToInt',
      {
        conditionalA,
        conditionalBool,
        conditional0,
        conditional3,
        conditionalMinus12,
        conditionalMinus7,
        conditionalMinus9,
        conditionalMinus8,
        conditionalStringFoo,
        conditionalStringBar
      },
      conditional3,
      conditions: {
        'inputTypes': {'value': int},
        'conditionTree': {
          BinaryExpressionTree(
              root: Node('&&',
                  left: Node('!=', left: Node('value'), right: Node('0')),
                  right: Node('>=', left: Node('value'), right: Node('3'))))
        }
      });
  Transition goToIntconditionalMinus12 = statemachine.newTransition(
      'goToInt',
      {
        conditionalA,
        conditionalBool,
        conditional0,
        conditional3,
        conditionalMinus12,
        conditionalMinus7,
        conditionalMinus9,
        conditionalMinus8,
        conditionalStringFoo,
        conditionalStringBar
      },
      conditionalMinus12,
      conditions: {
        'inputTypes': {'value': int},
        'conditionTree': {
          BinaryExpressionTree(
              root: Node('&&',
                  left: Node('&&',
                      left: Node('!=', left: Node('value'), right: Node('0')),
                      right: Node('<', left: Node('value'), right: Node('3'))),
                  right: Node('<=', left: Node('value'), right: Node('-12'))))
        }
      });
  Transition goToIntconditionalMinus7 = statemachine.newTransition(
      'goToInt',
      {
        conditionalA,
        conditionalBool,
        conditional0,
        conditional3,
        conditionalMinus12,
        conditionalMinus7,
        conditionalMinus9,
        conditionalMinus8,
        conditionalStringFoo,
        conditionalStringBar
      },
      conditionalMinus7,
      conditions: {
        'inputTypes': {'value': int},
        'conditionTree': {
          BinaryExpressionTree(
              root: Node('&&',
                  left: Node('&&',
                      left: Node('&&',
                          left:
                              Node('!=', left: Node('value'), right: Node('0')),
                          right:
                              Node('<', left: Node('value'), right: Node('3'))),
                      right:
                          Node('>', left: Node('value'), right: Node('-12'))),
                  right: Node('>', left: Node('value'), right: Node('-8'))))
        }
      });
  Transition goToIntconditionalMinus9 = statemachine.newTransition(
      'goToInt',
      {
        conditionalA,
        conditionalBool,
        conditional0,
        conditional3,
        conditionalMinus12,
        conditionalMinus7,
        conditionalMinus9,
        conditionalMinus8,
        conditionalStringFoo,
        conditionalStringBar
      },
      conditionalMinus9,
      conditions: {
        'inputTypes': {'value': int},
        'conditionTree': {
          BinaryExpressionTree(
              root: Node('&&',
                  left: Node('&&',
                      left: Node('&&',
                          left: Node('&&',
                              left: Node('!=',
                                  left: Node('value'), right: Node('0')),
                              right: Node('<',
                                  left: Node('value'), right: Node('3'))),
                          right: Node('>',
                              left: Node('value'), right: Node('-12'))),
                      right:
                          Node('<=', left: Node('value'), right: Node('-8'))),
                  right: Node('<', left: Node('value'), right: Node('-8'))))
        }
      });
  Transition goToIntconditionalMinus8 = statemachine.newTransition(
      'goToInt',
      {
        conditionalA,
        conditionalBool,
        conditional0,
        conditional3,
        conditionalMinus12,
        conditionalMinus7,
        conditionalMinus9,
        conditionalMinus8,
        conditionalStringFoo,
        conditionalStringBar
      },
      conditionalMinus8,
      conditions: {
        'inputTypes': {'value': int},
        'conditionTree': {
          BinaryExpressionTree(
              root: Node('&&',
                  left: Node('&&',
                      left: Node('&&',
                          left: Node('&&',
                              left: Node('!=',
                                  left: Node('value'), right: Node('0')),
                              right: Node('<',
                                  left: Node('value'), right: Node('3'))),
                          right: Node('>',
                              left: Node('value'), right: Node('-12'))),
                      right:
                          Node('<=', left: Node('value'), right: Node('-8'))),
                  right: Node('>=', left: Node('value'), right: Node('-8'))))
        }
      });
  Transition goToStringconditionalStringFoo = statemachine.newTransition(
      'goToString',
      {
        conditionalA,
        conditionalBool,
        conditional0,
        conditional3,
        conditionalMinus12,
        conditionalMinus7,
        conditionalMinus9,
        conditionalMinus8,
        conditionalStringFoo,
        conditionalStringBar
      },
      conditionalStringFoo,
      conditions: {
        'inputTypes': {'value': String},
        'conditionTree': {
          BinaryExpressionTree(
              root: Node('==', left: Node('value'), right: Node('foo')))
        }
      });
  Transition goToStringconditionalStringBar = statemachine.newTransition(
      'goToString',
      {
        conditionalA,
        conditionalBool,
        conditional0,
        conditional3,
        conditionalMinus12,
        conditionalMinus7,
        conditionalMinus9,
        conditionalMinus8,
        conditionalStringFoo,
        conditionalStringBar
      },
      conditionalStringBar,
      conditions: {
        'inputTypes': {'value': String},
        'conditionTree': {
          BinaryExpressionTree(
              root: Node('&&',
                  left: Node('!=', left: Node('value'), right: Node('foo')),
                  right: Node('==', left: Node('value'), right: Node('bar'))))
        }
      });

  // Define starting state
  statemachine.start(conditionalA);

  return statemachine;
}
