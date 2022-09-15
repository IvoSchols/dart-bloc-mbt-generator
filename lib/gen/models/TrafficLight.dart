  import 'package:state_machine/state_machine.dart';


  StateMachine constructTrafficLightStatemachine() {
  final statemachine = StateMachine('TrafficLight');

  // Define states
      final Red = statemachine.newState('Red');
      final Green = statemachine.newState('Green');
      final Yellow = statemachine.newState('Yellow');
      final Exception = statemachine.newState('Exception');
  

  // Define transitions and their conditions
        
      Transition changeTrafficLightTo = statemachine.newTransition('changeTrafficLightTo', {Red, Green, Yellow}, Red , conditions: inputTypes:{    {
              'color': String
      
    }
  }conditionTree: changeTrafficLightToBinaryExpressionTree);
          
      Transition changeTrafficLightTo = statemachine.newTransition('changeTrafficLightTo', {Red, Green, Yellow}, Green , conditions: inputTypes:{    {
              'color': String
      
    }
  }conditionTree: changeTrafficLightToBinaryExpressionTree);
          
      Transition changeTrafficLightTo = statemachine.newTransition('changeTrafficLightTo', {Red, Green, Yellow}, Yellow , conditions: inputTypes:{    {
              'color': String
      
    }
  }conditionTree: changeTrafficLightToBinaryExpressionTree);
          
      Transition changeTrafficLightTo = statemachine.newTransition('changeTrafficLightTo', {Red, Green, Yellow}, Exception , conditions: inputTypes:{    {
              'color': String
      
    }
  }conditionTree: changeTrafficLightToBinaryExpressionTree);
    

  // Define starting state
  statemachine.start(Red);

  return statemachine;
}

  