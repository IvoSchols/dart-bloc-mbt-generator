  import 'package:state_machine/state_machine.dart';


  StateMachine constructConditionalAbStatemachine() {
  final statemachine = StateMachine('ConditionalAb');

  // Define states
      final ConditionalA = statemachine.newState('ConditionalA');
      final ConditionalB = statemachine.newState('ConditionalB');
  

  // Define transitions and their conditions
        Transition goToA = statemachine.newTransition('goToA', {ConditionalA, ConditionalB}, ConditionalA );
          Transition goToB = statemachine.newTransition('goToB', {ConditionalA, ConditionalB}, ConditionalB , conditions:     {
              'allowed': bool
      
    }
  Closure: () => List<dynamic> from Function 'toPostFix':.);
    

  // Define starting state
  statemachine.start(ConditionalA);

  return statemachine;
}

  