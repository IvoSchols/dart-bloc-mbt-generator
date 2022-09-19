  import 'package:state_machine/state_machine.dart';


  StateMachine constructConditionalAbStatemachine() {
  final statemachine = StateMachine('ConditionalAb');

  // Define states
      final ConditionalA = statemachine.newState('ConditionalA');
      final ConditionalBool = statemachine.newState('ConditionalBool');
      final Conditional0 = statemachine.newState('Conditional0');
      final Conditional1 = statemachine.newState('Conditional1');
      final Conditional2 = statemachine.newState('Conditional2');
      final Conditional3 = statemachine.newState('Conditional3');
      final Conditional4 = statemachine.newState('Conditional4');
      final Conditional5 = statemachine.newState('Conditional5');
      final ConditionalStringFoo = statemachine.newState('ConditionalStringFoo');
      final ConditionalStringBar = statemachine.newState('ConditionalStringBar');
  

  // Define transitions and their conditions
        
      Transition goToA = statemachine.newTransition('goToA', {ConditionalA, ConditionalBool, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5, ConditionalStringFoo, ConditionalStringBar}, ConditionalA );
          
      Transition goToBool = statemachine.newTransition('goToBool', {ConditionalA, ConditionalBool, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5, ConditionalStringFoo, ConditionalStringBar}, ConditionalBool , conditions: inputTypes:{    {
              'allowed': bool
      
    }
  }conditionTree: goToBoolBinaryExpressionTree);
          
      Transition goToBool = statemachine.newTransition('goToBool', {ConditionalA, ConditionalBool, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5, ConditionalStringFoo, ConditionalStringBar}, ConditionalA , conditions: inputTypes:{    {
              'allowed': bool
      
    }
  });
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, ConditionalBool, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5, ConditionalStringFoo, ConditionalStringBar}, Conditional0 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, ConditionalBool, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5, ConditionalStringFoo, ConditionalStringBar}, Conditional1 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, ConditionalBool, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5, ConditionalStringFoo, ConditionalStringBar}, Conditional2 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, ConditionalBool, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5, ConditionalStringFoo, ConditionalStringBar}, Conditional3 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, ConditionalBool, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5, ConditionalStringFoo, ConditionalStringBar}, Conditional4 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, ConditionalBool, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5, ConditionalStringFoo, ConditionalStringBar}, Conditional5 , conditions: inputTypes:{    {
              'value': int
      
    }
  });
          
      Transition goToString = statemachine.newTransition('goToString', {ConditionalA, ConditionalBool, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5, ConditionalStringFoo, ConditionalStringBar}, ConditionalStringFoo , conditions: inputTypes:{    {
              'value': String
      
    }
  }conditionTree: goToStringBinaryExpressionTree);
          
      Transition goToString = statemachine.newTransition('goToString', {ConditionalA, ConditionalBool, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5, ConditionalStringFoo, ConditionalStringBar}, ConditionalStringBar , conditions: inputTypes:{    {
              'value': String
      
    }
  }conditionTree: goToStringBinaryExpressionTree);
    

  // Define starting state
  statemachine.start(ConditionalA);

  return statemachine;
}

  