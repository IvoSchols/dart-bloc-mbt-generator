import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class StatesVisitor extends SimpleAstVisitor {
  Set<String> states = {};
  String initialState = "";

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.toString() == "emit") return;
    String state = node.methodName.toString();
    state = state[0].toLowerCase() + state.substring(1);
    states.add(state);
  }

  @override
  void visitSuperConstructorInvocation(SuperConstructorInvocation node) {
    if (initialState.isNotEmpty) {
      throw Exception("Multiple superclasses found");
    }
    initialState =
        node.argumentList.arguments.first.childEntities.first.toString();
    initialState = initialState[0].toLowerCase() + initialState.substring(1);
  }
}
