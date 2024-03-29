import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/trace.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/trace_strategies/emit_strategy.dart';

class SwitchStrategy extends SimpleAstVisitor {
  final Set<Trace> traces = {};

  String _conditionName = '';

  SwitchStrategy(Trace currentTrace) {
    _currentTrace = currentTrace.copyWith();
  }

  late final Trace _currentTrace;

  @override
  void visitSwitchCase(SwitchCase node) {
    dynamic condition = node.expression;
    Node newNode;

    switch (_currentTrace.inputTypes[_conditionName]) {
      case 'bool':
        BooleanLiteral booleanLiteral = node.expression as BooleanLiteral;
        condition = booleanLiteral.value;
        if (condition) {
          newNode = Node(_conditionName);
        } else {
          newNode = Node('!');
          newNode.left = Node(_conditionName);
        }
        break;
      case 'int':
        int condition = num.parse(node.expression.toString()).toInt();
        newNode = Node('==');
        newNode.left = Node(_conditionName);
        newNode.right = Node(condition);
        break;
      case 'String':
        SimpleStringLiteral stringLiteral =
            node.expression as SimpleStringLiteral;
        condition = stringLiteral.value;
        newNode = Node('==');
        newNode.left = Node(_conditionName);
        newNode.right = Node(condition);
        break;
      default:
        throw Exception('Unknown type');
    }

    String toState = '';
    // Is this even needed?
    toState = visitExpressionStatement(
        node.statements.whereType<ExpressionStatement>().first);
    toState = toState[0].toLowerCase() + toState.substring(1);

    if (toState.isNotEmpty) {
      Trace newTrace = _currentTrace.copyWith(
          functionName: _currentTrace.functionName, toState: toState);
      newTrace.conditionTree.root = newNode;

      traces.add(newTrace);
    }
  }

  @override
  void visitSwitchDefault(SwitchDefault node) {
    // Loop through all traces and exclude their conditions
    BinaryExpressionTree zippedTree = BinaryExpressionTree();

    if (traces.isNotEmpty) {
      zippedTree = traces.first.conditionTree.copy();
      zippedTree.root?.invert();
      for (Trace trace in traces.skip(1)) {
        BinaryExpressionTree newTree = trace.conditionTree.copy();
        newTree.root?.invert();
        zippedTree = zippedTree.zip(newTree, Node('&&'));
      }
    }

    String toState = '';
    node.statements.whereType<ExpressionStatement>().forEach((e) {
      toState = visitExpressionStatement(e);
    });

    if (toState.isNotEmpty) {
      toState = toState[0].toLowerCase() + toState.substring(1);

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
