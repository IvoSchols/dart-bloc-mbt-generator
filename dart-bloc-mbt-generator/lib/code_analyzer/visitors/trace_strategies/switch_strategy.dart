import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/trace_strategies/emit_strategy.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/traces_visitor.dart';

class SwitchStrategy extends SimpleAstVisitor {
  final Set<Trace> traces = {};

  String _conditionName = '';

  SwitchStrategy(Trace currentTrace) {
    _currentTrace = currentTrace.copyWith();
  }

  late final Trace _currentTrace;

  @override
  void visitSwitchCase(SwitchCase node) {
    dynamic condition;
    if (_currentTrace.inputTypes[_conditionName] == 'String') {
      SimpleStringLiteral stringLiteral =
          node.expression as SimpleStringLiteral;
      condition = stringLiteral.value;
    } else {
      throw Exception('Unknown type');
    }

    Node newNode = Node('==');
    newNode.left = Node(_conditionName);
    newNode.right = Node(condition);

    String toState = '';
    node.statements.whereType<ExpressionStatement>().forEach((e) {
      toState = visitExpressionStatement(e);
    });

    if (toState.isNotEmpty) {
      Trace newTrace = _currentTrace.copyWith(
          functionName: _currentTrace.functionName, toState: toState);
      newTrace.addNode(newNode);

      traces.add(newTrace);
    }
  }

  @override
  void visitSwitchDefault(SwitchDefault node) {
    // Loop through all traces and exclude their conditions
    BinaryExpressionTree zippedTree = BinaryExpressionTree();

    if (traces.isNotEmpty) {
      zippedTree = traces.first.conditionTree.copy();
      zippedTree.negate();
      for (Trace trace in traces.skip(1)) {
        BinaryExpressionTree newTree = trace.conditionTree.copy();
        newTree.negate();
        zippedTree = zippedTree.zip(newTree, Node('&&'));
      }
    }

    String toState = '';
    node.statements.whereType<ExpressionStatement>().forEach((e) {
      toState = visitExpressionStatement(e);
    });

    if (toState.isNotEmpty) {
      // Add the zippedTree to the currentTrace
      Trace newTrace = _currentTrace.copyWith(
          functionName: _currentTrace.functionName,
          conditionTree: zippedTree,
          toState: toState);

      traces.add(newTrace);
    }
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    _conditionName = node.expression.toString();

    for (SwitchMember member in node.members) {
      if (member is SwitchCase &&
          _currentTrace.inputTypes.containsKey(_conditionName)) {
        visitSwitchCase(member);
      } else if (member is SwitchDefault) {
        visitSwitchDefault(member);
      }
    }
  }

  @override
  String visitExpressionStatement(ExpressionStatement node) {
    String toState = '';
    if (node.expression is MethodInvocation) {
      MethodInvocation methodInvocation = node.expression as MethodInvocation;
      if (methodInvocation.methodName.toString() == 'emit') {
        EmitStrategy strategy = EmitStrategy(_currentTrace);
        strategy.visitMethodInvocation(methodInvocation);

        toState = strategy.currentTrace.toState;
      }
    } else if (node.expression is ThrowExpression) {
      toState = 'Exception';
    }
    return toState;
  }
}
