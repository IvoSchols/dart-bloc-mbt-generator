import 'dart:collection';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/state_transition_tree/state_transition_tree.dart';
import 'package:state_machine/state_machine.dart';

import '../state_transition_tree/state_transition_node.dart';

class TransitionsListener extends EventListener {
  //TODO: find ways to identify when a transition is found and to build it and add it to the list of transitions when finished

  Set<Trace> traces = {};
  Set<StateTransitionTree> stateTransitionTrees = {};
  List<Node> _currentNodesTrace = [];

  @override
  void visitClassDeclaration(ClassDeclaration node) {}

  /// The first entry point for finding transitions.
  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    String functionName = node.name2.toString();
    // Set<String> illegalFromStates = {};
    // Set<String> fromStates = {}; // Set illegal and later subtract from states
    // String toState = "";
    // Set<String> conditions = {};
    LinkedHashMap<String, String> inputs = LinkedHashMap();
    List<Node> newCurrentNodesTrace = [];
    FunctionNode newFunctionNode = FunctionNode(functionName);

    newCurrentNodesTrace.add(newFunctionNode);

    _currentNodesTrace = newCurrentNodesTrace;
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.toString() == "emit") return;
    if (_currentNodesTrace.isEmpty) return;

    Node toNode = Node(node.methodName.toString());

    _currentNodesTrace.add(toNode);

    traces.add(Trace.fromNodeList(_currentNodesTrace));
    _currentNodesTrace = [];
  }

  // Read conditions of the transition/method
  @override
  void visitSimpleFormalParameter(SimpleFormalParameter node) {
    if (_currentNodesTrace.isEmpty) return;
    assert(_currentNodesTrace.last is FunctionNode,
        "Current node is not a function node");

    FunctionNode functionNode = _currentNodesTrace.last as FunctionNode;

    String name = node.name.toString();

    if (functionNode.parameters.containsKey(name)) {
      throw "Input name already exists";
    }

    String type = node.type.toString();

    functionNode.parameters[name] = type;
  }

  @override
  void visitIfElement(IfElement node) {
    assert(_currentNodesTrace.isNotEmpty, "No current state transition tree");

    //TODO: add implementation for multiple conditions

    String condition = node.condition.toString();
    Node newNode = ConstraintNode(condition);
    _currentNodesTrace.add(newNode);
  }
}

class Trace {
  final String functionName;
  final Set<String> illegalFromStates;
  final String toState;
  final Set<String> conditions;
  final LinkedHashMap<String, String> inputs;

  Trace(
      {required this.functionName,
      required this.illegalFromStates,
      required this.toState,
      required this.conditions,
      required this.inputs});

  factory Trace.fromNodeList(List<dynamic> nodeList) {
    String functionName = "";
    Set<String> illegalFromStates = {};
    String toState = "";
    Set<String> conditions = {};
    LinkedHashMap<String, String> inputs = LinkedHashMap();

    for (dynamic node in nodeList) {
      if (node is FunctionNode) {
        assert(functionName.isEmpty, "Function name already set");

        functionName = node.value;

        for (String key in node.parameters.keys) {
          assert(!inputs.containsKey(key), "Input name already exists");
          assert(node.parameters[key] != null, "Input type is null");

          inputs[key] = node.parameters[key].toString();
        }
      } else if (node is ConstraintNode) {
        assert(!conditions.contains(node.value), "Condition already exists");

        conditions.add(node.value);
        illegalFromStates.addAll(node.illegalFromStates);
      } else if (node is Node) {
        toState = node.value;
      } else {
        throw "Unknown node type";
      }
    }
    if (functionName.isEmpty) {
      throw "Function name is empty";
    }
    if (toState.isEmpty) {
      throw "To state is empty";
    }
    return Trace(
        functionName: functionName,
        illegalFromStates: illegalFromStates,
        toState: toState,
        conditions: conditions,
        inputs: inputs);
  }
}
