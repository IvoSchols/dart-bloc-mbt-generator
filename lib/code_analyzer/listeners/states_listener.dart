import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';

class StatesListener extends EventListener {
  Set<String> states = {};
  String startingState = "";

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.toString() == "emit") return;
    String state = node.methodName.toString();
    states.add(state);
  }

  @override
  void visitSuperConstructorInvocation(SuperConstructorInvocation node) {
    if (startingState.isNotEmpty) {
      throw Exception("Multiple superclasses found");
    }
    startingState =
        node.argumentList.arguments.first.childEntities.first.toString();
  }
}
