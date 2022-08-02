import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'package:statemachine/statemachine.dart';

/// A visitor that visits the AST and returns a [StateMachine]
class CubitVisitor extends SimpleAstVisitor<void> {
  @override
  // Find states and events of the FiniteStateMachineCubit class, if one is not found return null
  // Also provide a leg up on transition function
  Machine visitClassDeclaration(ClassDeclaration node) {
    if (node.extendsClause == null ||
        node.extendsClause!.superclass.name.toString() != "Cubit") {
      throw Exception("Not a Cubit class");
    }
    if (node.extendsClause!.superclass.typeArguments ==
            null || // TODO: Necessary line?
        node.extendsClause!.superclass.typeArguments!.arguments.isEmpty) {
      throw Exception("No machine states provided");
    }
    String name = "";
    List<State> states = [];
    List<String> stateTransitions = [];

    Machine stateMachine = new Machine<String>();

    //Find states
    //TODO: find a way to get the events -> remove null
    node.extendsClause!.superclass.typeArguments!.arguments.forEach((element) {
      states.add(stateMachine.newState(element.toString()));
    });

    //Find events & create state
    node.childEntities.forEach((childEntity) {
      if (childEntity is MethodDeclaration) {
        stateTransitions.add(visitMethodDeclaration(childEntity));
      }
    });
    return stateMachine;
  }

  @override
  String visitMethodDeclaration(MethodDeclaration node) {
    return node.name.name;
  }
}
