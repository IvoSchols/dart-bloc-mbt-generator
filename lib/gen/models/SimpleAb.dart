import 'package:state_machine/state_machine.dart';

// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine constructSimpleAbStatemachine() {
  final statemachine = StateMachine('simple_ab');

  // Define states
  
    final simpleA = statemachine.newState('SimpleA');
  
    final simpleB = statemachine.newState('SimpleB');
  

  // Define transitions
  
    StateTransition  = statemachine.newStateTransition('', [], {SimpleA});
  
    StateTransition  = statemachine.newStateTransition('', [], {SimpleB});
  

  // Define starting state
  statemachine.start(simpleA);

  return statemachine;
}
