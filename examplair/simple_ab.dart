import 'package:state_machine/state_machine.dart';

// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine constructSimpleAbStatemachine() {
  final statemachine = StateMachine('simple_ab');

  // Define states
  
    final simpleA() = statemachine.newState('SimpleA()');
  
    final simpleB() = statemachine.newState('SimpleB()');
  

  // Define transitions
  
    StateTransition goToA = statemachine.newTransition(goToA, [[SimpleA(),SimpleB()]], simpleA());
  
    StateTransition goToB = statemachine.newTransition(goToB, [[SimpleA(),SimpleB()]], simpleB());
  

  // Define starting state
  statemachine.start(simpleA());

  return statemachine;
}
