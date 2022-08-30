import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';

class StatesListener extends EventListener {
  Set<String> states = {};

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.toString() == "emit") return;
    String state = node.methodName.toString();
    states.add(state);
  }
}
