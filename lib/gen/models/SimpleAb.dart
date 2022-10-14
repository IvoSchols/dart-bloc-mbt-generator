import 'package:simple_state_machine/state_machine.dart';

StateMachine constructSimpleAbStatemachine() {
  final statemachine = StateMachine('SimpleAb');

  // Define states
  final SimpleA = statemachine.newState('SimpleA');
  final SimpleB = statemachine.newState('SimpleB');

  // Define transitions and their conditions

  Transition goToA =
      statemachine.newTransition('goToA', {SimpleA, SimpleB}, SimpleA);

  Transition goToB =
      statemachine.newTransition('goToB', {SimpleA, SimpleB}, SimpleB);

  // Define starting state
  statemachine.start(SimpleA);

  return statemachine;
}
