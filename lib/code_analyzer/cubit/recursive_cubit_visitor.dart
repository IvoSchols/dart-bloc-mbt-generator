import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';

// Recursive visitor to find states, events, transitions and initial state of a cubit
class RecursiveCubitVisitor extends RecursiveAstVisitor
    implements EventListener {
  RecursiveCubitVisitor({
    required this.onVisitClassDeclaration,
    required this.onVisitSuperConstructorInvocation,
    required this.onVisitMethodInvocation,
    required this.onVisitMethodDeclaration,
    required this.onVisitSimpleFormalParameter,
    required this.onVisitIfElement,
  });

  void Function(ClassDeclaration node) onVisitClassDeclaration;
  void Function(SuperConstructorInvocation node)
      onVisitSuperConstructorInvocation;
  void Function(MethodInvocation node) onVisitMethodInvocation;
  void Function(MethodDeclaration node) onVisitMethodDeclaration;
  void Function(SimpleFormalParameter node) onVisitSimpleFormalParameter;
  void Function(IfElement node) onVisitIfElement;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    onVisitClassDeclaration(node);
    super.visitClassDeclaration(node);
  }

  @override
  void visitSuperConstructorInvocation(SuperConstructorInvocation node) {
    onVisitSuperConstructorInvocation(node);
    super.visitSuperConstructorInvocation(node);
  }

  @override
  visitMethodInvocation(MethodInvocation node) {
    onVisitMethodInvocation(node);
    return super.visitMethodInvocation(node);
  }

  @override
  visitMethodDeclaration(MethodDeclaration node) {
    onVisitMethodDeclaration(node);
    return super.visitMethodDeclaration(node);
  }

  @override
  visitSimpleFormalParameter(SimpleFormalParameter node) {
    onVisitSimpleFormalParameter(node);
    return super.visitSimpleFormalParameter(node);
  }

  @override
  visitIfElement(IfElement node) {
    onVisitIfElement(node);
    return super.visitIfElement(node);
  }
}
