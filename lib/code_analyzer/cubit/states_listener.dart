import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';

class StatesListener implements EventListener {
  Set<String> states = {};

  @override
  void onMethodInvocation(MethodInvocation node) {
    if (node.methodName.toString() == "emit") return;
    String state = node.methodName.toString();
    states.add(state);
  }

  @override
  void onClassDeclaration(ClassDeclaration node) {
    // TODO: implement onClassDeclaration
  }

  @override
  void onMethodDeclaration(MethodDeclaration node) {
    // TODO: implement onMethodDeclaration
  }

  @override
  void onSuperConstructorInvocation(SuperConstructorInvocation node) {
    // TODO: implement onSuperConstructorInvocation
  }
}
