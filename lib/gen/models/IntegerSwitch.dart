  import 'package:state_machine/state_machine.dart';


  StateMachine constructIntegerSwitchStatemachine() {
  final statemachine = StateMachine('IntegerSwitch');

  // Define states
      final Zero = statemachine.newState('Zero');
      final Minus20 = statemachine.newState('Minus20');
      final FourtySeven = statemachine.newState('FourtySeven');
      final Exception = statemachine.newState('Exception');
  

  // Define transitions and their conditions
        
      Transition integerSwitch = statemachine.newTransition('integerSwitch', {Zero, Minus20, FourtySeven}, Minus20 , conditions: inputTypes:{    {
              'integer': int
      
    }
  }conditionTree: integerSwitchBinaryExpressionTree);
          
      Transition integerSwitch = statemachine.newTransition('integerSwitch', {Zero, Minus20, FourtySeven}, FourtySeven , conditions: inputTypes:{    {
              'integer': int
      
    }
  }conditionTree: integerSwitchBinaryExpressionTree);
          
      Transition integerSwitch = statemachine.newTransition('integerSwitch', {Zero, Minus20, FourtySeven}, Exception , conditions: inputTypes:{    {
              'integer': int
      
    }
  }conditionTree: integerSwitchBinaryExpressionTree);
    

  // Define starting state
  statemachine.start(Zero);

  return statemachine;
}

  