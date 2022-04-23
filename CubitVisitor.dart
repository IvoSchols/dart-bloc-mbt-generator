import 'dart:ffi';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'FiniteStateMachine.dart';
import 'FiniteStateMachineCubit.dart';

/// A visitor that visits the AST and returns a [FiniteStateMachineCubit]
class CubitVisitor extends SimpleAstVisitor<void> {
  @override
  // Find states and events of the FiniteStateMachineCubit class, if one is not found return null
  // Also provide a leg up on transition function
  FiniteStateMachineCubit? visitClassDeclaration(ClassDeclaration node) {
    String name = "";
    Set<dynamic> states = Set();
    Set<dynamic> events = Set();
    Map<Tuple, dynamic> transitionFunction = Map();

    if (node.extendsClause != null &&
        node.extendsClause!.superclass.name.toString() == "Cubit") {
      name = node.name.toString();
      //Find name of FSM, by only removing 'Cubit' from class name if it is the last word
      if (name.endsWith("Cubit")) {
        name = name.substring(0, name.length - 5);
      }
      //Find states
      //Return null if no state is found
      if (node.extendsClause!.superclass.typeArguments ==
              null || // TODO: Necessary line?
          node.extendsClause!.superclass.typeArguments!.arguments.isEmpty) {
        return null;
      }
      states = node.extendsClause!.superclass.typeArguments!.arguments
          .map((e) => e.toString())
          .toSet();

      //Find events
      node.childEntities.forEach((childEntity) {
        if (childEntity is MethodDeclaration) {
          events.add(visitMethodDeclaration(childEntity));
        }
      });
    }
    //Check if variables are set, if not return null
    //If so, return FiniteStateMachineCubit
    if (name == "" ||
        states.length == 0 ||
        events.length == 0 ||
        transitionFunction.isEmpty) {
      return null;
    }
    return FiniteStateMachineCubit(
        name, states, events, null, Set<String>(), transitionFunction);
  }

  @override
  String visitMethodDeclaration(MethodDeclaration node) {
    return node.name.name;
    print(node.toString());
  }
}
