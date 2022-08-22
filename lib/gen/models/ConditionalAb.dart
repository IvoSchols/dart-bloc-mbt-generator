import 'package:state_machine/state_machine.dart';

// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine constructConditionalAbStatemachine() {
  final statemachine = StateMachine('conditional_ab');

  // Define states
  
    final conditionalA = statemachine.newState('ConditionalA');
  
    final conditionalB = statemachine.newState('ConditionalB');
  

  // Define transitions
  
    StateTransition  = statemachine.newStateTransition('', [conditionalA,conditionalB,], {ConditionalA});
  
    StateTransition  = statemachine.newStateTransition('', [conditionalA,conditionalB,], {});
  

  // Define starting state
  statemachine.start(conditionalA);

  return statemachine;
}
