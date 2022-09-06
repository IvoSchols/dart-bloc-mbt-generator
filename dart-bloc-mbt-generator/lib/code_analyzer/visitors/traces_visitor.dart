import 'dart:collection';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/trace_strategies/if_element_strategy.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/trace_strategies/method_declaration_strategy.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/trace_strategies/method_invocation_strategy.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/trace_strategies/switch_strategy.dart';

class TracesVisitor extends SimpleAstVisitor {
  final Set<Trace> traces = {};

  final ListQueue<Trace> _currentTraceStack = ListQueue();

  Trace? get _currentTrace =>
      _currentTraceStack.isEmpty ? null : _currentTraceStack.last;

  /// The first entry point for finding transitions.
  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    assert(_currentTrace == null, 'A trace is already being built');

    MethodDeclarationStrategy strategy = MethodDeclarationStrategy();
    strategy.visitMethodDeclaration(node);
    _currentTraceStack.add(strategy.currentTrace);
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

    IfElementStrategy strategy = IfElementStrategy(_currentTrace!);
    strategy.visitIfElement(node);
    _currentTraceStack.add(strategy.currentTrace);
  }

  // Emit()
  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (_currentTrace == null) return;
    // TODO: If emit -> call emitStratey
    if (node.methodName.toString() == "emit") return;
    MethodInvocationStrategy strategy =
        MethodInvocationStrategy(_currentTrace!);
    strategy.visitMethodInvocation(node);

    traces.add(strategy.currentTrace);
    _currentTraceStack.removeLast(); // Remove method declaration trace
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    assert(_currentTrace != null, "No current state transition tree");
    SwitchStrategy switchStrategy = SwitchStrategy(_currentTrace!);
    switchStrategy.visitSwitchStatement(node);
    //TODO: add getter for currentTrace from switchStrategyVisitor
  }
}

///
///
///

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
    BinaryExpressionTree? conditionTree,
    LinkedHashMap<String, String>? inputTypes,
  }) {
    return Trace(
      functionName: functionName ?? this.functionName,
      illegalFromStates: illegalFromStates ?? this.illegalFromStates,
      toState: toState ?? this.toState,
      conditionTree: conditionTree ?? this.conditionTree,
      inputTypes: inputTypes ?? this.inputTypes,
    );
  }
}
