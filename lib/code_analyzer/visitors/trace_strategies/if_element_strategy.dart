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
    String condition = node.condition.toString();

    Node newNode = _buildIfNode(condition);
    _currentTrace.addNode(newNode);
  }
}

Node _buildIfNode(String condition) {
  Node node = Node(condition);
  if (condition[0] == '!') {
    node = Node(condition[0]);
    node.left = _buildIfNode(condition.substring(1));
  }
  return node;
}
