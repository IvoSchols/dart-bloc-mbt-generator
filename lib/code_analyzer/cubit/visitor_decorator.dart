// A decorator that adds visitor methods to a visitor.
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/visitor.dart';

class VisitorDecorator implements Visitor {
  final Visitor _wrappee;

  VisitorDecorator(this._wrappee);

  @override
  void onClassDeclaration(ClassDeclaration node) {
    _wrappee.onClassDeclaration(node);
  }

  @override
  void onMethodDeclaration(MethodDeclaration node) {
    _wrappee.onMethodDeclaration(node);
  }

  @override
  void onMethodInvocation(MethodInvocation node) {
    _wrappee.onMethodInvocation(node);
  }

  @override
  void onSuperConstructorInvocation(SuperConstructorInvocation node) {
    _wrappee.onSuperConstructorInvocation(node);
  }
}
