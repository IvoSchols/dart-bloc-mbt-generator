import 'package:state_machine/state_machine.dart';

// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine constructSimpleAbCubitStatemachine() {
  final statemachine = StateMachine('simple_ab_cubit');

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
