import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:simple_state_machine/state_machine.dart';

String stateMachineTemplate(StateMachine sm) {
  final String name = sm.name;
  final Set<State> states = sm.states;
  final State startingState = sm.initial;

  return '''
  import 'package:simple_state_machine/state_machine.dart';
  import 'package:binary_expression_tree/binary_expression_tree.dart';



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
      statemachine.newTransition('${t.name}', ${t.from.map((f) => f.name).toSet()}, ${t.to.name} ${t.conditions != null ? ', conditions: ${_conditions(t.name, t.conditions!)}' : ''});
    ''').join();

String _conditions(String transitionName, Map<dynamic, dynamic> conditions) {
  String conditionString = '';
  bool hasInputTypes = conditions['inputTypes'] != null;
  bool hasConditionTree = conditions['conditionTree'] != null;

  if (hasInputTypes || hasConditionTree) {
    conditionString += '{';

    if (hasInputTypes) {
      conditionString +=
          "'inputTypes':{${_inputTypes(conditions['inputTypes'])}},";
    }
    if (hasConditionTree) {
      conditionString +=
          "'conditionTree':${_conditionTree(conditions['conditionTree'])}";
    }

    conditionString += '}';
  }

  return conditionString;
}

String _inputTypes(Map<String, String> inputTypes) =>
    inputTypes.entries.map((e) => '''
        '${e.key}': '${e.value}'
      ''').join();

String _conditionTree(BinaryExpressionTree conditionTree) {
  if (conditionTree.root == null) return '';
  String ctString = "BinaryExpressionTree(";

  ctString += "root:";
  // visit all binary expression tree nodes in preorder and add them to the string
  ctString += _conditionTreeNodes(conditionTree.root!);

  ctString += ')';

  return ctString;
}

String _conditionTreeNodes(Node node) {
  // Try to parse nodeValue as int
  // If nodeValue is not an int (== null), it is a string
  int? nodeValueAsInt = int.tryParse(node.value);

  String nodeString = "Node(";

  if (nodeValueAsInt == null) {
    nodeString += "'${node.value}'";
  } else {
    nodeString += nodeValueAsInt.toString();
  }

  if (node.left != null) {
    nodeString += ", left: ";
    nodeString += _conditionTreeNodes(node.left!);
  }
  if (node.right != null) {
    nodeString += ", right: ";
    nodeString += _conditionTreeNodes(node.right!);
  }

  nodeString += ')';

  return nodeString;
}
