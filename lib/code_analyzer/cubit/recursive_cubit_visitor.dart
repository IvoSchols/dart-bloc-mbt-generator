import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';
import 'package:equatable/equatable.dart';

class VisitedCubit {
  String name;
  Set<String> states;
  Map<String, String> variables; // Stores relation: name -> type
  Set<Transition> transitions;
  String startingState;

  VisitedCubit(this.name, this.states, this.variables, this.transitions,
      this.startingState);
}

class Transition extends Equatable {
  final String functionName;
  final Set<String> illegalFromStates;
  final Set<String> fromStates;
  final Set<String> toStates;
  final Set<bool Function()> conditions;
  final Set<Function()> inputs;

  Transition(this.functionName, this.illegalFromStates, this.fromStates,
      this.toStates, this.conditions, this.inputs);

  Transition copyWith({
    String? functionName,
    Set<String>? illegalFromStates,
    Set<String>? fromStates,
    Set<String>? toStates,
    Set<bool Function()>? conditions,
    Set<Function()>? inputs,
  }) {
    return Transition(
      functionName ?? this.functionName,
      illegalFromStates ?? this.illegalFromStates,
      fromStates ?? this.fromStates,
      toStates ?? this.toStates,
      conditions ?? this.conditions,
      inputs ?? this.inputs,
    );
  }

  @override
  List<Object> get props => [
        functionName,
        illegalFromStates,
        fromStates,
        toStates,
        conditions,
        inputs,
      ];
}

// Recursive visitor to find states, events, transitions and initial state of a cubit
class RecursiveCubitVisitor extends RecursiveAstVisitor
    implements EventListener {
  RecursiveCubitVisitor({
    required this.onVisitClassDeclaration,
    required this.onVisitSuperConstructorInvocation,
    required this.onVisitMethodInvocation,
    required this.onVisitMethodDeclaration,
  });

  void Function(ClassDeclaration node) onVisitClassDeclaration;
  void Function(SuperConstructorInvocation node)
      onVisitSuperConstructorInvocation;
  void Function(MethodInvocation node) onVisitMethodInvocation;
  void Function(MethodDeclaration node) onVisitMethodDeclaration;

  // //Transitions
  // for (var member in node.members) {
  //   if (member is MethodDeclarationImpl) {
  //     String event = member.name.toString();
  //     for (var argument in member.body.childEntities) {
  //       if (argument is MethodInvocationImpl) {
  //         String to = argument.argumentList.arguments[0].childEntities.first
  //             .toString();
  //         transitions.add(CubitStateTransition(event, states.toList(), to));
  //       }
  //     }
  //   }
  // }

  // if (transitions.isEmpty) {
  //   throw Exception("Could not find transitions");
  // }

  // return VisitedCubit('', states, transitions, '');

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    onVisitClassDeclaration(node);
    super.visitClassDeclaration(node);
  }

  @override
  void visitSuperConstructorInvocation(SuperConstructorInvocation node) {
    onVisitSuperConstructorInvocation(node);
    super.visitSuperConstructorInvocation(node);
  }

  @override
  visitMethodInvocation(MethodInvocation node) {
    onVisitMethodInvocation(node);
    return super.visitMethodInvocation(node);
  }

  @override
  visitMethodDeclaration(MethodDeclaration node) {
    onVisitMethodDeclaration(node);
    return super.visitMethodDeclaration(node);
  }
}
