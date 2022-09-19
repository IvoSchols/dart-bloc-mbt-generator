  import 'package:state_machine/state_machine.dart';


  StateMachine constructConditionalAbComplexStatemachine() {
  final statemachine = StateMachine('ConditionalAbComplex');

  // Define states
      final ConditionalA = statemachine.newState('ConditionalA');
      final Conditional0 = statemachine.newState('Conditional0');
      final Conditional1 = statemachine.newState('Conditional1');
      final Conditional2 = statemachine.newState('Conditional2');
      final Conditional3 = statemachine.newState('Conditional3');
      final Conditional4 = statemachine.newState('Conditional4');
      final Conditional5 = statemachine.newState('Conditional5');
  

  // Define transitions and their conditions
        
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5}, Conditional0 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5}, Conditional1 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5}, Conditional2 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5}, Conditional3 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5}, Conditional4 , conditions: inputTypes:{    {
              'value': int
      
    }
  }conditionTree: goToIntBinaryExpressionTree);
          
      Transition goToInt = statemachine.newTransition('goToInt', {ConditionalA, Conditional0, Conditional1, Conditional2, Conditional3, Conditional4, Conditional5}, Conditional5 , conditions: inputTypes:{    {
              'value': int
      
    }
  });
    

  // Define starting state
  statemachine.start(ConditionalA);

  return statemachine;
}

  