import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:bloc/bloc.dart';

import 'package:state_machine/state_machine.dart';

/// A visitor that visits the AST and returns a [StateMachine]
/// TODO: recursively find all potential candidates for state machines
class CubitVisitor extends SimpleAstVisitor<void> {
  @override
  // Find states and events of the FiniteStateMachineCubit class, if one is not found return null
  // Also provide a leg up on transition function
  dynamic visitClassDeclaration(ClassDeclaration node) {
    if (node.extendsClause == null ||
        node.extendsClause!.superclass.name.toString() != "Cubit") {
      throw Exception("Not a Cubit class");
    }
    //Junk?
    if (node.extendsClause!.superclass.typeArguments ==
            null || // TODO: Necessary line?
        node.extendsClause!.superclass.typeArguments!.arguments.isEmpty) {
      throw Exception("No machine states provided");
    }
    String name = "";

    // Find starting state
    String startingState = _findStartingState(node);
    if (startingState == "") {
      throw Exception("No starting state provided");
    }

    //Find states
    //TODO: find a way to get the events -> remove null
    Set<String> states = _findStates(node);

    if (states.isEmpty) {
      throw Exception("No states are emitted");
    }

    states.add(startingState);

    //Find transitions
    List<CubitStateTransition> stateTransitions =
        _findTransitions(states, node);

    dynamic result = {
      'name': name,
      'states': states,
      'transitions': stateTransitions,
      'startingState': startingState
    };

    return result;
  }

  @override
  String visitMethodDeclaration(MethodDeclaration node) {
    return node.name.name;
  }

  String _findStartingState(ClassDeclaration node) {
    String startingState = "";
    ClassMember startingStateMember = node.members[0];
    for (dynamic childEntity in startingStateMember.childEntities) {
      if (childEntity is SuperConstructorInvocationImpl) {
        startingState = childEntity.argumentList.toString();
        startingState = startingState.substring(1, startingState.length - 1);
        break;
      }
    }
    return startingState;
  }

  Set<String> _findStates(ClassDeclaration node) {
    Set<String> states = {};
    for (var member in node.members) {
      if (member is MethodDeclarationImpl) {
        for (var argument in member.body.childEntities) {
          if (argument is MethodInvocationImpl) {
            states.add(argument.argumentList.arguments[0].toString());
          }
        }
      }
    }
    return states;
  }

  List<CubitStateTransition> _findTransitions(
      Set<String> states, ClassDeclaration node) {
    List<CubitStateTransition> transitions = [];

    for (var member in node.members) {
      if (member is MethodDeclarationImpl) {
        String event = member.name.toString();
        for (var argument in member.body.childEntities) {
          if (argument is MethodInvocationImpl) {
            String to = argument.argumentList.arguments[0].toString();
            transitions.add(CubitStateTransition(event, states.toList(), to));
          }
        }
      }
    }

    return transitions;
  }
}

class CubitStateTransition {
  String event;
  List<String> fromState;
  String toState;

  CubitStateTransition(this.event, this.fromState, this.toState);
}
