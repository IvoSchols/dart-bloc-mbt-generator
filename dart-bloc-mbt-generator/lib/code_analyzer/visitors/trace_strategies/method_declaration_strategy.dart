import 'dart:collection';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/traces_visitor.dart';

class MethodDeclarationStrategy extends SimpleAstVisitor {
  MethodDeclarationStrategy();

  late final Trace _currentTrace;

  get currentTrace => _currentTrace;

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

    _currentTrace = newTrace;
  }

  // @override
  // void visitMethodDeclaration(MethodDeclaration node) {
  //   String methodName = node.name.toString();
  //   String methodBody = node.body.toString();
  //   String methodParameters = node.parameters.toString();

  //   Node newNode = Node(methodName);
  //   newNode.left = Node(methodBody);
  //   newNode.right = Node(methodParameters);

  //   _currentTrace.addNode(newNode);
  // }

}
