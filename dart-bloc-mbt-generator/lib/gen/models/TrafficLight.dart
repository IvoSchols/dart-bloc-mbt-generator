  import 'package:state_machine/state_machine.dart';


  StateMachine constructTrafficLightStatemachine() {
  final statemachine = StateMachine('TrafficLight');

  // Define states
      final Red = statemachine.newState('Red');
      final Green = statemachine.newState('Green');
      final Yellow = statemachine.newState('Yellow');
      final Exception = statemachine.newState('Exception');
  

  // Define transitions and their conditions
        Transition changeTrafficLightTocolorRed = statemachine.newTransition('changeTrafficLightTocolorRed', {Red, Green, Yellow}, Red , conditions:     {
              'color': String
      
    }
  Closure: () => List<dynamic> from Function 'toPostFix':.);
          Transition changeTrafficLightTocolorGreen = statemachine.newTransition('changeTrafficLightTocolorGreen', {Red, Green, Yellow}, Green , conditions:     {
              'color': String
      
    }
  Closure: () => List<dynamic> from Function 'toPostFix':.);
          Transition changeTrafficLightTocolorYellow = statemachine.newTransition('changeTrafficLightTocolorYellow', {Red, Green, Yellow}, Yellow , conditions:     {
              'color': String
      
    }
  Closure: () => List<dynamic> from Function 'toPostFix':.);
          Transition changeTrafficLightTodefault = statemachine.newTransition('changeTrafficLightTodefault', {Red, Green, Yellow}, Exception , conditions:     {
              'color': String
      
    }
  Closure: () => List<dynamic> from Function 'toPostFix':.);
    

  // Define starting state
  statemachine.start(Red);

  return statemachine;
}

  