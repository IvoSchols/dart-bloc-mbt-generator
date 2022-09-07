import 'dart:collection';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/trace_strategies/if_element_strategy.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/trace_strategies/method_declaration_strategy.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/trace_strategies/emit_strategy.dart';
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

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (_currentTrace == null) return;
    if (node.methodName.toString() == "emit") {
      EmitStrategy strategy = EmitStrategy(_currentTrace!);
      strategy.visitMethodInvocation(node);

      traces.add(strategy.currentTrace);
      // Remove method declaration trace (prob not best way)
      _currentTraceStack.removeLast();
    }
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

  void setInputTypes(LinkedHashMap<String, String> inputTypes) {
    for (String element in this.inputTypes.keys) {
      assert(!inputTypes.containsKey(element), "Input name already exists");
    }
    this.inputTypes.addAll(inputTypes);
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
      conditionTree: conditionTree ?? this.conditionTree.copy(),
      inputTypes: inputTypes ?? this.inputTypes,
    );
  }
}
