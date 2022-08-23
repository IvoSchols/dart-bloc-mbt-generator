import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';

String stateMachineTemplate(VisitedCubit vCubit) {
  final String name = vCubit.name;
  final Set<String> states = vCubit.states;
  final Set<Transition> transitions = vCubit.transitions;
  final String startingState = vCubit.startingState;

  return '''
  // @dart=2.9
  import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
  import 'package:state_machine/state_machine.dart';


  // Construct a statemachine with two states (A, B) and one transition (A->B)
  StateMachine construct${name}Statemachine() {
  final statemachine = StateMachine('$name');

  // Define states
  ${_states(states)}

  // Define transitions and their conditions
  ${_transitions(transitions)}

  // Define starting state
  statemachine.start($startingState);

  return statemachine;
}

  ''';
}

String _states(Set<String> states) => states.map((state) => '''
    final $state = statemachine.newState('$state');
  ''').join();

String _transitions(Set<Transition> transitions) => transitions.map((t) => ''' 
      StateTransition ${t.functionName} = statemachine.newStateTransition('${t.functionName}', ${t.fromStates.toList().toString()}, ${t.toState});


      ${_conditions(t.functionName, t.conditions)}
    ''').join();

//TODO: probably update when more complex conditions are added
String _conditions(String transitionName, Set<String> conditions) =>
    conditions.map((c) => '''
      $transitionName.cancelIf((StateChange change) => !change.payload.$c);
    ''').join();
