import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:equatable/equatable.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:state_machine/state_machine.dart';

/// A visitor that visits the AST and returns a [StateMachine]
/// TODO: recursively find all potential candidates for state machines
class CubitVisitor extends SimpleAstVisitor<VisitedCubit> {
  @override
  // Find states and events of the FiniteStateMachineCubit class, if one is not found return null
  // Also provide a leg up on transition function
  VisitedCubit visitClassDeclaration(ClassDeclaration node) {
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

    String name =
        node.name.toString().replaceFirst(RegExp("'cubit'|'Cubit'"), '');

    // Find starting state
    String startingState = _findStartingState(node);
    if (startingState == "") {
      throw Exception("No starting state found in class declaration");
    }

    AstVisitor visitor = _RecursiveCubitVisitor();
    VisitedCubit result = visitor.visitClassDeclaration(node);

    result.name = name;
    result.startingState = startingState;
    result.states.add(startingState);

    return result;
  }

  String _findStartingState(ClassDeclaration node) {
    String startingState = "";
    ClassMember startingStateMember = node.members[0];
    for (dynamic childEntity in startingStateMember.childEntities) {
      if (childEntity is SuperConstructorInvocationImpl) {
        startingState = childEntity
            .argumentList.arguments[0].childEntities.first
            .toString();
        break;
      }
    }
    return startingState;
  }
}

class VisitedCubit {
  String name;
  Set<String> states;
  List<CubitStateTransition> transitions;
  String startingState;

  VisitedCubit(this.name, this.states, this.transitions, this.startingState);
}

class CubitStateTransition extends Equatable {
  final String event;
  final List<String> fromState;
  final String toState;
  final List<Function>? conditions;

  CubitStateTransition(this.event, this.fromState, this.toState,
      {this.conditions});

  @override
  List<Object> get props => [event, fromState, toState];
}

// Recursive visitor to find states, events, transitions and initial state of a cubit
class _RecursiveCubitVisitor extends RecursiveAstVisitor<VisitedCubit> {
  @override
  VisitedCubit visitClassDeclaration(ClassDeclaration node) {
    // VisitedCubit? foundCubit = super.visitClassDeclaration(node);

    // if (foundCubit == null) {
    //   throw Exception("Could not find cubit");
    // }

    //Find states
    Set<String> states = _findStates(node);
    //Find transitions
    List<CubitStateTransition> transitions = _findTransitions(states, node);

    if (states.isEmpty || transitions.isEmpty) {
      throw Exception("Could not initialize all variables");
    }

    return VisitedCubit('', states, transitions, '');
  }

  //Recursively find all states (1st level)
  @override
  VisitedCubit visitMethodDeclaration(MethodDeclaration node) {
    Set<String> states = {};
    // super.visitMethodDeclaration(node);
    for (SyntacticEntity childEntity in node.body.childEntities) {
      // TODO: Cannot use is keyword?
      if (childEntity.runtimeType.toString() == "SimpleToken") {
        continue;
      }
      //Find state
      if (childEntity is MethodInvocationImpl) {
        states.addAll(visitMethodInvocation(childEntity).states);
      }
      // Find state with condition
      if (childEntity is ExpressionFunctionBody) {
        for (SyntacticEntity childEntity in childEntity.childEntities) {
          if (childEntity is SetOrMapLiteral) {
            for (SyntacticEntity child
                in childEntity.elements[0].childEntities) {
              if (child.toString() == "thenElement") {
                // states.addAll(visitMethodInvocation(child).states);
                print("scoobadoo");
              }
            }
            // states.add(
            //     child.argumentList.arguments[0].childEntities.first.toString());
          }
        }
      }
    }
    return VisitedCubit('', states, [], '');
  }

  @override
  VisitedCubit visitMethodInvocation(MethodInvocation node) {
    Set<String> states = {};

    // Base case: add states with structure: emit(state)
    if (node.argumentList.arguments.length == 1) {
      states.add(node.argumentList.arguments[0].childEntities.first.toString());
    }

    // Find deeper states (not yet implemented!)
    VisitedCubit? result = super.visitMethodInvocation(node);
    if (result == null) {
      return VisitedCubit('', states, [], '');
    }
    result.states.addAll(states);
    return result;
  }

  Set<String> _findStates(ClassDeclaration node) {
    Set<String> states = {};
    for (var member in node.members) {
      if (member is MethodDeclarationImpl) {
        VisitedCubit visitedCubit = visitMethodDeclaration(member);
        states.addAll(visitedCubit.states);
      }
    }
    if (states.isEmpty) {
      throw Exception("Could not find states");
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
            String to = argument.argumentList.arguments[0].childEntities.first
                .toString();
            transitions.add(CubitStateTransition(event, states.toList(), to));
          }
        }
      }
    }

    return transitions;
  }
}
