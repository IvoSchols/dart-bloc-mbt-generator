import 'dart:collection';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';

class TracesListener extends EventListener {
  Trace? _currentTrace;
  final Set<Trace> traces = {};

  /// The first entry point for finding transitions.
  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    assert(_currentTrace == null, 'A trace is already being built');

    String functionName = node.name2.toString();

    BinaryExpressionTree newTraceTree = BinaryExpressionTree();
    //TODO: call formal parameters strategy
    LinkedHashMap<String, String> inputs =
        LinkedHashMap(); // Is this already known at this point?
    Trace newTrace = Trace(
        functionName: functionName,
        conditionTree: newTraceTree,
        inputTypes: inputs);

    _currentTrace = newTrace;
  }

  // Read conditions of the transition/method
  @override
  void visitSimpleFormalParameter(SimpleFormalParameter node) {
    if (_currentTrace == null) return;
    assert(_currentTrace!.currentNode == null);

    String name = node.name.toString();

    if (_currentTrace!.inputTypes.containsKey(name)) {
      throw "Input name already exists";
    }

    String type = node.type.toString();

    _currentTrace!.inputTypes[name] = type;
  }

  @override
  void visitIfElement(IfElement node) {
    assert(_currentTrace != null, "No current state transition tree");

    //TODO: add implementation for multiple conditions
    String condition = node.condition.toString();

    String trueState =
        node.thenElement.toString(); //TODO: what to do with this?

    Node newNode = _buildIfNode(condition);
    _currentTrace!.addNode(newNode);
  }

  Node _buildIfNode(String condition) {
    Node node = Node(condition);
    if (condition[0] == '!') {
      node = Node(condition[0]);
      node.left = _buildIfNode(condition.substring(1));
    }
    return node;
  }

  // Emit()
  @override
  void visitMethodInvocation(MethodInvocation node) {
    // TODO: If emit -> call emitStratey
    if (node.methodName.toString() == "emit") return;
    if (_currentTrace == null) return;
    // assert(_currentTraceNode != null, "No current node");

    String toState = node.methodName.toString();

    // assert(!_currentTraceNode!.hasChildren(), "Node cannot have children");

    _currentTrace!.toState = toState;

    traces.add(_currentTrace!);
    _currentTrace!.currentNode = null;
    _currentTrace = null;
  }
}

class Trace {
  final String functionName;
  late Set<String> illegalFromStates;
  late String toState;
  final BinaryExpressionTree conditionTree;
  final LinkedHashMap<String, String> inputTypes;

  Node? currentNode;

  Trace(
      {required this.functionName,
      required this.conditionTree,
      required this.inputTypes,
      illegalFromStates,
      toState}) {
    this.illegalFromStates = illegalFromStates ?? {};
    this.toState = toState ?? "";
  }

  void addNode(Node child) {
    if (conditionTree.root == null) {
      conditionTree.root = child;
    } else {
      assert(!currentNode!.hasChildren());
      currentNode!.addChild(child);
    }
  }

  // Is a deep copy of binary expression tree needed?
  Trace copyWith({
    String? functionName,
    Set<String>? illegalFromStates,
    String? toState,
    BinaryExpressionTree? conditions,
    LinkedHashMap<String, String>? inputs,
  }) {
    return Trace(
      functionName: functionName ?? this.functionName,
      illegalFromStates: illegalFromStates ?? this.illegalFromStates,
      toState: toState ?? this.toState,
      conditionTree: conditions ?? this.conditionTree,
      inputTypes: inputs ?? this.inputTypes,
    );
  }
}
