// A decorator that adds visitor methods to a visitor.
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';

abstract class EventListener {
  void visitClassDeclaration(ClassDeclaration node) {}

  void visitMethodDeclaration(MethodDeclaration node) {}

  void visitMethodInvocation(MethodInvocation node) {}

  void visitSuperConstructorInvocation(SuperConstructorInvocation node) {}
}
