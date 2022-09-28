  import 'package:state_machine/state_machine.dart';


  StateMachine constructLightSwitchStatemachine() {
  final statemachine = StateMachine('LightSwitch');

  // Define states
      final Off = statemachine.newState('Off');
      final On = statemachine.newState('On');
  

  // Define transitions and their conditions
        
      Transition lightSwitch = statemachine.newTransition('lightSwitch', {Off, On}, On , conditions: inputTypes:{    {
              'on': bool
      
    }
  }conditionTree: lightSwitchBinaryExpressionTree);
          
      Transition lightSwitch = statemachine.newTransition('lightSwitch', {Off, On}, Off , conditions: inputTypes:{    {
              'on': bool
      
    }
  }conditionTree: lightSwitchBinaryExpressionTree);
    

  // Define starting state
  statemachine.start(Off);

  return statemachine;
}

  