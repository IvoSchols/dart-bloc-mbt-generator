import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../FiniteStateMachine/FiniteStateMachine.dart';
import '../../FiniteStateMachine/FiniteStateMachineCubit.dart';

/// A visitor that visits the AST and returns a [FiniteStateMachineCubit]
class CubitVisitor extends SimpleAstVisitor<void> {
  @override
  // Find states and events of the FiniteStateMachineCubit class, if one is not found return null
  // Also provide a leg up on transition function
  FiniteStateMachineCubit? visitClassDeclaration(ClassDeclaration node) {
    String name = "";
    Set<String> states = Set();
    Set<String> events = Set();
    Map<Tuple, String> transitionFunction = Map();

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
    if (name == "" || states.length == 0 || events.length == 0) {
      return null;
    }
    return FiniteStateMachineCubit(
        name, states, events, transitionFunction, "initialState", Set());
  }

  @override
  String visitMethodDeclaration(MethodDeclaration node) {
    return node.name.name;
  }
}
