  import 'package:simple_state_machine/state_machine.dart';


  StateMachine constructConditionalAbComplexStatemachine() {
  final statemachine = StateMachine('ConditionalAbComplex');

  // Define states
      final ConditionalA = statemachine.newState('ConditionalA');
      final ConditionalBool = statemachine.newState('ConditionalBool');
      final Conditional0 = statemachine.newState('Conditional0');
      final Conditional3 = statemachine.newState('Conditional3');
      final ConditionalMinus12 = statemachine.newState('ConditionalMinus12');
      final ConditionalMinus7 = statemachine.newState('ConditionalMinus7');
      final ConditionalMinus9 = statemachine.newState('ConditionalMinus9');
      final ConditionalMinus8 = statemachine.newState('ConditionalMinus8');
      final ConditionalStringFoo = statemachine.newState('ConditionalStringFoo');
      final ConditionalStringBar = statemachine.newState('ConditionalStringBar');
  

  // Define transitions and their conditions
        
      Transition goToA = statemachine.newTransition('goToA', {ConditionalA, ConditionalBool, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8, ConditionalStringFoo, ConditionalStringBar}, ConditionalA );
          
      Transition goToBool = statemachine.newTransition('goToBool', {ConditionalA, ConditionalBool, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8, ConditionalStringFoo, ConditionalStringBar}, ConditionalBool , conditions: inputTypes:{    {
              'allowed': bool
      
    }
  }conditionTree: goToBoolBinaryExpressionTree);
          
      Transition goToBool = statemachine.newTransition('goToBool', {ConditionalA, ConditionalBool, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8, ConditionalStringFoo, ConditionalStringBar}, ConditionalA , conditions: inputTypes:{    {
              'allowed': bool
      
    }
  }conditionTree: goToBoolBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, ConditionalBool, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8, ConditionalStringFoo, ConditionalStringBar}, Conditional0 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, ConditionalBool, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8, ConditionalStringFoo, ConditionalStringBar}, Conditional3 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, ConditionalBool, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8, ConditionalStringFoo, ConditionalStringBar}, ConditionalMinus12 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, ConditionalBool, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8, ConditionalStringFoo, ConditionalStringBar}, ConditionalMinus7 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, ConditionalBool, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8, ConditionalStringFoo, ConditionalStringBar}, ConditionalMinus9 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, ConditionalBool, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8, ConditionalStringFoo, ConditionalStringBar}, ConditionalMinus8 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToString = statemachine.newTransition('goToString', {ConditionalA, ConditionalBool, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8, ConditionalStringFoo, ConditionalStringBar}, ConditionalStringFoo , conditions: inputTypes:{    {
              'value': String
      
    }
  }conditionTree: goToStringBinaryExpressionTree);
          
      Transition goToString = statemachine.newTransition('goToString', {ConditionalA, ConditionalBool, Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8, ConditionalStringFoo, ConditionalStringBar}, ConditionalStringBar , conditions: inputTypes:{    {
              'value': String
      
    }
  }conditionTree: goToStringBinaryExpressionTree);
    

  // Define starting state
  statemachine.start(ConditionalA);

  return statemachine;
}

  