// A decorator that adds visitor methods to a visitor.
import 'package:analyzer/dart/ast/ast.dart';

abstract class EventListener {
  void visitClassDeclaration(ClassDeclaration node) {}

  void visitMethodDeclaration(MethodDeclaration node) {}

  void visitMethodInvocation(MethodInvocation node) {}

  void visitSuperConstructorInvocation(SuperConstructorInvocation node) {}

  void visitSimpleFormalParameter(SimpleFormalParameter node) {}

  void visitIfElement(IfElement node) {}

  void visitSwitchCase(SwitchCase node) {}

  void visitSwitchDefault(SwitchDefault node) {}

  void visitSwitchStatement(SwitchStatement node) {}
}
