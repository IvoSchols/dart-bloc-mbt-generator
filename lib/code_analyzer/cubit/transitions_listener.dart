import 'dart:collection';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/state_transition_tree/state_transition_tree.dart';

import '../state_transition_tree/state_transition_node.dart';

class TransitionsListener extends EventListener {
  //TODO: find ways to identify when a transition is found and to build it and add it to the list of transitions when finished
  StateTransitionTree? _currentStateTransitionTree;
  Node? _currentNode;

  Set<StateTransitionTree> stateTransitionTrees = {};

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

    FunctionNode newFunctionNode = FunctionNode(functionName);
    StateTransitionTree newStateTransitionTree =
        StateTransitionTree(root: newFunctionNode);

    _currentStateTransitionTree = newStateTransitionTree;
    _currentNode = newFunctionNode;
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.toString() == "emit") return;
    if (_currentStateTransitionTree == null) return;
    assert(_currentNode != null, "No current node");

    Node toNode = Node(node.methodName.toString());

    assert(!_currentNode!.hasChildren(), "Node cannot have children");

    _currentNode!.addChild(toNode);
    _currentNode = toNode;

    stateTransitionTrees.add(_currentStateTransitionTree!);
    _currentStateTransitionTree = null;
  }

  // Read conditions of the transition/method
  @override
  void visitSimpleFormalParameter(SimpleFormalParameter node) {
    if (_currentStateTransitionTree == null) return;
    assert(_currentNode != null, "No current node");
    assert(_currentNode is FunctionNode, "Current node is not a function node");

    FunctionNode functionNode = _currentNode as FunctionNode;

    String name = node.name.toString();

    if (functionNode.parameters.containsKey(name)) {
      throw "Input name already exists";
    }

    String type = node.type.toString();

    functionNode.parameters[name] = type;
  }

  @override
  void visitIfElement(IfElement node) {
    assert(_currentStateTransitionTree != null,
        "No current state transition tree");
    assert(_currentNode != null, "No current node");

    //TODO: add implementation for multiple conditions

    String condition = node.condition.toString();
    Node newNode = ConstraintNode(condition);
    _currentNode!.addChild(newNode);
    _currentNode = newNode;
  }
}
