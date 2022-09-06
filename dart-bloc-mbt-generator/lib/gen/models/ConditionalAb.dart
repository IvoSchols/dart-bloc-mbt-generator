  import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
  import 'package:state_machine/state_machine.dart';


  StateMachine constructConditionalAbStatemachine() {
  final statemachine = StateMachine('ConditionalAb');

  // Define states
      final State(ConditionalA, Instance of 'StateMachine') = statemachine.newState('State(ConditionalA, Instance of 'StateMachine')');
      final State(ConditionalB, Instance of 'StateMachine') = statemachine.newState('State(ConditionalB, Instance of 'StateMachine')');
  

  // Define transitions and their conditions
        Transition goToA = statemachine.newStateTransition('goToA', [State(ConditionalA, Instance of 'StateMachine'), State(ConditionalB, Instance of 'StateMachine')], State(ConditionalA, Instance of 'StateMachine'));


          goToA: conditions.toPostFix().toString();
    
          Transition goToB = statemachine.newStateTransition('goToB', [State(ConditionalA, Instance of 'StateMachine'), State(ConditionalB, Instance of 'StateMachine')], State(ConditionalB, Instance of 'StateMachine'));


          goToB: conditions.toPostFix().toString();
    
     //?

  // Define starting state
  statemachine.start(State(ConditionalA, Instance of 'StateMachine'));

  return statemachine;
}

  