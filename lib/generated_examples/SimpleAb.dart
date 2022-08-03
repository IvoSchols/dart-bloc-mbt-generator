import 'package:state_machine/state_machine.dart';

// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine constructSimpleAbStatemachine() {
  final statemachine = StateMachine('simple_ab');

  // Define states
  
    final simpleA = statemachine.newState('SimpleA');
  
    final simpleB = statemachine.newState('SimpleB');
  

  // Define transitions
  
    StateTransition goToA = statemachine.newStateTransition('goToA', [simpleA,simpleB,], simpleA);
  
    StateTransition goToB = statemachine.newStateTransition('goToB', [simpleA,simpleB,], simpleB);
  

  // Define starting state
  statemachine.start(simpleA);

  return statemachine;
}
