import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/cubit_visitor.dart';
import 'package:equatable/equatable.dart';

///Interface for the visitor pattern.
abstract class Visitor {
  // VisitedCubit visit(AstVisitor visitor);
  void onClassDeclaration(ClassDeclaration node);
  void onSuperConstructorInvocation(SuperConstructorInvocation node);
  void onMethodInvocation(MethodInvocation node);
  void onMethodDeclaration(MethodDeclaration node);
}

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
  Set<String> fromState;
  final String toState;
  final Set<bool Function()> conditions;
  final Set<Function()> inputs;

  Transition(this.functionName, this.fromState, this.toState, this.conditions,
      this.inputs);

  @override
  List<Object> get props => [
        functionName,
        fromState,
        toState,
        conditions,
        inputs,
      ];
}
