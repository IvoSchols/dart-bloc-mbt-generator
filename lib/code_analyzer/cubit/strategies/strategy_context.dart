import 'package:analyzer/dart/ast/ast.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';

class StrategyContext implements EventListener {
  StrategyContext? _nestedContext;

  BinaryExpressionTree? _currentTree;
  Node? _currentNode;
  Set<BinaryExpressionTree> trees = {};

  void setStrategy(StrategyContext context) {
    // _context = context;
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    // TODO: implement visitClassDeclaration
  }

  @override
  void visitIfElement(IfElement node) {
    // TODO: implement visitIfElement
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    // TODO: implement visitMethodDeclaration
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // TODO: implement visitMethodInvocation
  }

  @override
  void visitSimpleFormalParameter(SimpleFormalParameter node) {
    // TODO: implement visitSimpleFormalParameter
  }

  @override
  void visitSuperConstructorInvocation(SuperConstructorInvocation node) {
    // TODO: implement visitSuperConstructorInvocation
  }
}
