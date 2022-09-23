import 'dart:collection';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/trace.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/trace_strategies/emit_strategy.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/trace_strategies/if_element_strategy.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/trace_strategies/switch_strategy.dart';

class MethodDeclarationStrategy extends RecursiveAstVisitor {
  final Set<Trace> traces = {};

  final ListQueue<Trace> _currentTraceStack = ListQueue();

  Trace? get _currentTrace =>
      _currentTraceStack.isEmpty ? null : _currentTraceStack.last;

  CollectionElement? _elseElement; // Used for if statements

  /// The first entry point for finding transitions.
  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    String functionName = node.name2.toString();

    BinaryExpressionTree newTraceTree = BinaryExpressionTree();
    LinkedHashMap<String, String> inputs =
        LinkedHashMap(); // Is this already known at this point?
    Trace newTrace = Trace(
        functionName: functionName,
        conditionTree: newTraceTree,
        inputTypes: inputs);

    _currentTraceStack.add(newTrace);

    node.visitChildren(this);
  }

  // Read conditions of the transition/method
  @override
  void visitSimpleFormalParameter(SimpleFormalParameter node) {
    if (_currentTrace == null) return;

    String name = node.name.toString();

    if (_currentTrace!.inputTypes.containsKey(name)) {
      throw "Input name already exists";
    }

    String type = node.type.toString();

    _currentTrace!.inputTypes[name] = type;

    node.visitChildren(this);
  }

  @override
  void visitIfElement(IfElement node) {
    assert(_currentTrace != null, "No trace found");

    IfElementStrategy strategy =
        IfElementStrategy(_currentTrace!, _elseElement);
    strategy.visitIfElement(node);
    _currentTraceStack.add(strategy.currentTrace);

    _elseElement = node.elseElement;
    node.visitChildren(this);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (_currentTrace == null) return;
    if (node.methodName.toString() == "emit") {
      EmitStrategy strategy = EmitStrategy(_currentTrace!);
      strategy.visitMethodInvocation(node);

      traces.add(strategy.currentTrace);
      // Remove method declaration trace (prob not best way)
      if (_elseElement == null) {
        // _currentTraceStack.clear();
        _currentTraceStack.removeLast();
      }
    }

    node.visitChildren(this);
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    assert(_currentTrace != null, "No trace found");

    SwitchStrategy switchStrategy = SwitchStrategy(_currentTrace!);
    switchStrategy.visitSwitchStatement(node);
    traces.addAll(switchStrategy.traces);

    if (switchStrategy.traces.isNotEmpty) {
      _currentTraceStack.removeLast();
    }
    //TODO: add getter for currentTrace from switchStrategyVisitor

    node.visitChildren(this);
  }
}
