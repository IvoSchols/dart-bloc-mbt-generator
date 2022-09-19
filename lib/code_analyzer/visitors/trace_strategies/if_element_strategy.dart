import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/traces_visitor.dart';

class IfElementStrategy extends SimpleAstVisitor {
  IfElementStrategy(Trace currentTrace) {
    _currentTrace = currentTrace.copyWith();
  }

  late final Trace _currentTrace;

  get currentTrace => _currentTrace;

  @override
  void visitIfElement(IfElement node) {
    Node newNode = _buildIfNode(node.condition);
    _currentTrace.addNode(newNode);
  }
}

Node _buildIfNode(Expression condition) {
  //TODO: add fail condition if not unary or binary expression
  if (condition is BinaryExpression) {
    return _buildBinaryExpressionNode(condition);
  } else {
    return _buildUnaryExpressionNode(condition.toString());
  }
}

Node _buildUnaryExpressionNode(String condition) {
  Node node = Node(condition);
  if (condition[0] == '!') {
    node = Node(condition[0]);
    node.left = _buildUnaryExpressionNode(condition.substring(1));
  }
  return node;
}

Node _buildBinaryExpressionNode(BinaryExpression condition) {
  Node node = Node(condition.operator.lexeme);
  node.left = _buildIfNode(condition.leftOperand);
  node.right = _buildIfNode(condition.rightOperand);
  return node;
}
