import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:state_machine/state_machine.dart';

String stateMachineTemplate(StateMachine sm) {
  final String name = sm.name;
  final Set<State> states = sm.states;
  final State startingState = sm.initial;

  return '''
  import 'package:state_machine/state_machine.dart';


  StateMachine construct${name}Statemachine() {
  final statemachine = StateMachine('$name');

  // Define states
  ${_states(states)}

  // Define transitions and their conditions
  ${_transitions(states.map((state) => state.transitions).expand((element) => element).toSet())}

  // Define starting state
  statemachine.start(${startingState.name});

  return statemachine;
}

  ''';
}

String _states(Set<State> states) => states.map((state) => '''
    final ${state.name} = statemachine.newState('${state.name}');
  ''').join();

String _transitions(Set<Transition> transitions) => transitions.map((t) => ''' 
      Transition ${t.name} = statemachine.newTransition('${t.name}', ${t.from.map((f) => f.name).toSet()}, ${t.to.name} ${t.conditions != null ? ', conditions: ${_conditions(t.name, t.conditions!)}' : ''});
    ''').join();

//TODO: probably update when more complex conditions are added
//TODO: unfold binary expression tree correctly
String _conditions(String transitionName, Map<dynamic, dynamic> conditions) =>
    '''
    ''';
