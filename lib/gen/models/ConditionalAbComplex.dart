  import 'package:state_machine/state_machine.dart';


  StateMachine constructConditionalAbComplexStatemachine() {
  final statemachine = StateMachine('ConditionalAbComplex');

  // Define states
      final ConditionalA = statemachine.newState('ConditionalA');
      final Conditional0 = statemachine.newState('Conditional0');
      final Conditional3 = statemachine.newState('Conditional3');
      final ConditionalMinus12 = statemachine.newState('ConditionalMinus12');
      final ConditionalMinus7 = statemachine.newState('ConditionalMinus7');
      final ConditionalMinus9 = statemachine.newState('ConditionalMinus9');
      final ConditionalMinus8 = statemachine.newState('ConditionalMinus8');
  

  // Define transitions and their conditions
        
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8}, Conditional0 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8}, Conditional3 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8}, ConditionalMinus12 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8}, ConditionalMinus7 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8}, ConditionalMinus9 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8}, ConditionalMinus8 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
    

  // Define starting state
  statemachine.start(ConditionalA);

  return statemachine;
}

  