import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
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

// Recursive visitor to find states, events, transitions and initial state of a cubit
class RecursiveCubitVisitor extends RecursiveAstVisitor {
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

  // //Recursively find all states (1st level)
  // @override
  // VisitedCubit visitMethodDeclaration(MethodDeclaration node) {
  //   VisitedCubit result = VisitedCubit('', {}, [], '');
  //   // super.visitMethodDeclaration(node);
  //   for (SyntacticEntity childEntity in node.body.childEntities) {
  //     // TODO: Cannot use is keyword?
  //     if (childEntity.runtimeType.toString() == "SimpleToken") {
  //       continue;
  //     }
  //     //Find state wrapped in a direct function call
  //     if (childEntity is MethodInvocationImpl) {
  //       result.states.addAll(visitMethodInvocation(childEntity).states);
  //     }
  //     // Find state wrapped in a function body with a single expression
  //     if (node.body is ExpressionFunctionBodyImpl) {
  //       // Find function parameters
  //       if (node.parameters!.length != 0 &&
  //           node.parameters!.childEntities.isNotEmpty) {
  //         _FindFunctionParameters(node);
  //       }
  //     }
  //   }
  //   return result;
  // }

  // List<FunctionParameter> _FindFunctionParameters(var node) {
  //   List<FunctionParameter> functionParameters = [];
  //   for (var childEntity in node.parameters!.childEntities) {
  //     List<Function> functions;
  //     if (childEntity is SimpleFormalParameterImpl) {
  //       for (var childEntity2 in childEntity.childEntities) {
  //         FunctionParameter functionParameter = FunctionParameter("", "");
  //         if (childEntity2 is NamedTypeImpl) {
  //           functionParameter.type = childEntity2.toString();
  //           if (functionParameter.type != "bool")
  //             throw Exception("Unimplemented type");
  //         }
  //         if (childEntity2 is DeclaredSimpleIdentifier) {
  //           functionParameter.name = childEntity2.toString();
  //         }
  //         if (functionParameter.isNotEmpty) {
  //           functionParameters.add(functionParameter);
  //         }
  //       }
  //     }
  //   }
  //   return functionParameters;
  // }
}
