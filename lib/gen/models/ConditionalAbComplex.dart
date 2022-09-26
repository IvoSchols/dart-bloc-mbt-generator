  import 'package:state_machine/state_machine.dart';


  StateMachine constructConditionalAbComplexStatemachine() {
  final statemachine = StateMachine('ConditionalAbComplex');

  // Define states
      final ConditionalA = statemachine.newState('ConditionalA');
      final ConditionalStringFoo = statemachine.newState('ConditionalStringFoo');
      final ConditionalStringBar = statemachine.newState('ConditionalStringBar');
  

  // Define transitions and their conditions
        
      Transition goToA = statemachine.newTransition('goToA', {ConditionalA, ConditionalStringFoo, ConditionalStringBar}, ConditionalA );
          
      Transition goToString = statemachine.newTransition('goToString', {ConditionalA, ConditionalStringFoo, ConditionalStringBar}, ConditionalStringFoo , conditions: inputTypes:{    {
              'value': String
      
    }
  }conditionTree: goToStringBinaryExpressionTree);
          
      Transition goToString = statemachine.newTransition('goToString', {ConditionalA, ConditionalStringFoo, ConditionalStringBar}, ConditionalStringBar , conditions: inputTypes:{    {
              'value': String
      
    }
  }conditionTree: goToStringBinaryExpressionTree);
    

  // Define starting state
  statemachine.start(ConditionalA);

  return statemachine;
}

  