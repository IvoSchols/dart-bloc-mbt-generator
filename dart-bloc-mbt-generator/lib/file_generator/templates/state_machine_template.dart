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

//TODO: implement conditions correctly (and its subfunctions)
String _conditions(String transitionName, Map<dynamic, dynamic> conditions) {
  String inputTypes = conditions['inputTypes'].toString();
  String conditionTree = _conditionTree(conditions['conditionTree']);

  String conditionString = '';

  if (inputTypes.isNotEmpty) {
    conditionString += 'inputTypes: $inputTypes, ';
  }
  if (conditionTree.isNotEmpty) {
    conditionString += 'conditionTree: $conditionTree, ';
  }

  return conditionString;
}

String _inputTypes(Map<String, String> inputTypes) => '''
    {
      ${inputTypes.entries.map((e) => '''
        '${e.key}': ${e.value}
      ''').join()}
    }
  ''';

String _conditionTree(BinaryExpressionTree conditionTree) {
  return conditionTree.toPostFix.toString();
}
