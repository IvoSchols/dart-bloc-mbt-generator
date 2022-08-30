import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:state_machine/state_machine.dart';

String stateMachineTemplate(StateMachine sm) {
  final String name = sm.name;
  final List<State> states = sm.states;
  final State startingState = sm.initial;

  return '''
  import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
  import 'package:state_machine/state_machine.dart';


  StateMachine construct${name}Statemachine() {
  final statemachine = StateMachine('$name');

  // Define states
  ${_states(states)}

  // Define transitions and their conditions
  ${_transitions(states.map((state) => state.transitions).expand((element) => element).toList())} //?

  // Define starting state
  statemachine.start($startingState);

  return statemachine;
}

  ''';
}

String _states(List<State> states) => states.map((state) => '''
    final $state = statemachine.newState('$state');
  ''').join();

String _transitions(List<Transition> transitions) => transitions.map((t) => ''' 
      Transition ${t.name} = statemachine.newStateTransition('${t.name}', ${t.from.toList().toString()}, ${t.to});


      ${_conditions(t.name, t.conditions ?? BinaryExpressionTree())}
    ''').join();

//TODO: probably update when more complex conditions are added
//TODO: unfold binary expression tree correctly
String _conditions(String transitionName, BinaryExpressionTree conditions) =>
    '''
    $transitionName: conditions.toPostFix().toString();
    ''';
