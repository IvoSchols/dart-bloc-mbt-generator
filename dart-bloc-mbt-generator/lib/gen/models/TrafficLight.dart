  import 'package:state_machine/state_machine.dart';


  StateMachine constructTrafficLightStatemachine() {
  final statemachine = StateMachine('TrafficLight');

  // Define states
      final Red = statemachine.newState('Red');
      final Green = statemachine.newState('Green');
      final Yellow = statemachine.newState('Yellow');
      final Exception = statemachine.newState('Exception');
  

  // Define transitions and their conditions
        
      Transition changeTrafficLightTocolorRed = statemachine.newTransition('changeTrafficLightTocolorRed', {Red, Green, Yellow}, Red , conditions: inputTypes:{    {
              'color': String
      
    }
  }conditionTree: changeTrafficLightTocolorRedBinaryExpressionTree);
          
      Transition changeTrafficLightTocolorGreen = statemachine.newTransition('changeTrafficLightTocolorGreen', {Red, Green, Yellow}, Green , conditions: inputTypes:{    {
              'color': String
      
    }
  }conditionTree: changeTrafficLightTocolorGreenBinaryExpressionTree);
          
      Transition changeTrafficLightTocolorYellow = statemachine.newTransition('changeTrafficLightTocolorYellow', {Red, Green, Yellow}, Yellow , conditions: inputTypes:{    {
              'color': String
      
    }
  }conditionTree: changeTrafficLightTocolorYellowBinaryExpressionTree);
          
      Transition changeTrafficLightTodefault = statemachine.newTransition('changeTrafficLightTodefault', {Red, Green, Yellow}, Exception , conditions: inputTypes:{    {
              'color': String
      
    }
  }conditionTree: changeTrafficLightTodefaultBinaryExpressionTree);
    

  // Define starting state
  statemachine.start(Red);

  return statemachine;
}

  