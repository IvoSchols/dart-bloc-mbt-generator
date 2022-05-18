import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../FiniteStateMachine/FiniteStateMachineBase.dart';
import '../../FiniteStateMachine/FiniteStateMachineCubit.dart';

/// A visitor that visits the AST and returns a [FiniteStateMachineCubit]
class CubitVisitor extends SimpleAstVisitor<void> {
  @override
  // Find states and events of the FiniteStateMachineCubit class, if one is not found return null
  // Also provide a leg up on transition function
  FiniteStateMachineCubit? visitClassDeclaration(ClassDeclaration node) {
    String name = "";
    Set<State> states = Set();
    List<String> events = [];

    if (node.extendsClause != null &&
        node.extendsClause!.superclass.name.toString() == "Cubit") {
      name = node.name.toString();

      //Find states
      //Return null if no state is found
      if (node.extendsClause!.superclass.typeArguments ==
              null || // TODO: Necessary line?
          node.extendsClause!.superclass.typeArguments!.arguments.isEmpty) {
        return null;
      }
      //TODO: find a way to get the events -> remove null
      states = node.extendsClause!.superclass.typeArguments!.arguments
          .map((e) => State(e.toString()))
          .toSet();

      //Find events & create state
      node.childEntities.forEach((childEntity) {
        if (childEntity is MethodDeclaration) {
          events.add(visitMethodDeclaration(childEntity));
        }
      });
    }
    //Check if variables are set, if not return null
    //If so, return FiniteStateMachineCubit
    if (name == "" || states.length == 0 || events.length == 0) {
      return null;
    }
    return FiniteStateMachineCubit(
        name: name,
        states: states,
        events: events,
        initialState:
            states.first, // TODO: find a way to inference initialState
        finalStates: Set());
  }

  @override
  String visitMethodDeclaration(MethodDeclaration node) {
    return node.name.name;
  }
}