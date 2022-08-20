// A decorator that adds visitor methods to a visitor.
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';

abstract class EventListener {
  void onClassDeclaration(ClassDeclaration node);

  void onMethodDeclaration(MethodDeclaration node);

  void onMethodInvocation(MethodInvocation node);

  void onSuperConstructorInvocation(SuperConstructorInvocation node);
}
