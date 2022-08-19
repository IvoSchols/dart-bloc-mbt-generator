import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/visitor.dart';
import 'package:equatable/equatable.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:state_machine/state_machine.dart';

class CubitVisitor implements Visitor {
  String classDeclaration = "";
  String superclassName = "";
  final Set<String> methodInvocation = {};
  final Set<Transition> methodDeclaration = {};

  visit(ClassDeclaration node) {
    VisitedCubit result;
    String name;
    Set<String> states = {};
    Map<String, String> variables = {};
    Set<Transition> transitions = {};
    String startingState;

    _RecursiveCubitVisitor recursiveAstVisitor = _RecursiveCubitVisitor(
      onVisitClassDeclaration: onClassDeclaration,
      onVisitSuperConstructorInvocation: onSuperConstructorInvocation,
      onVisitMethodInvocation: onMethodInvocation,
      onVisitMethodDeclaration: onMethodDeclaration,
    );
    recursiveAstVisitor.visitClassDeclaration(node);

    // Name of the cubit
    if (classDeclaration.isEmpty) throw Exception("No class declaration found");
    name = classDeclaration;

    // Name of the starting state
    if (superclassName.isEmpty) throw Exception("No superclass found");
    startingState = superclassName;

    // States of the cubit
    if (methodInvocation.isEmpty) throw Exception("No method invocation found");
    states = methodInvocation;

    // Transitions of the cubit
    if (methodDeclaration.isEmpty) {
      throw Exception("No method declaration is found");
    }

    methodDeclaration.map((e) => e.fromState = states);
    transitions = methodDeclaration;

    result = VisitedCubit(
      name,
      states,
      variables,
      transitions,
      startingState,
    );
    return result;
  }

  /// Extracts the name of the class (and removes the 'Cubit' suffix)
  /// Requirement: class name must not be 'empty' (i.e. no name)
  @override
  onClassDeclaration(ClassDeclaration node) {
    if (node.extendsClause == null ||
        node.extendsClause!.superclass.name.toString() != "Cubit") {
      throw Exception("Not a Cubit class");
    }
    if (classDeclaration.isNotEmpty) {
      throw Exception("Multiple class declarations found");
    }

    String name = node.name.toString();
    name = name.replaceFirst(RegExp("cubit|Cubit"), '', name.length - 5);

    classDeclaration = name;
  }

  /// Extracts the name of the superclass
  @override
  onSuperConstructorInvocation(SuperConstructorInvocation node) {
    // Means that there are multiple starting states
    if (superclassName.isNotEmpty) {
      throw Exception("Multiple superclasses found");
    }
    superclassName = node.constructorName.toString();
  }

  /// Extracts the states of the cubit
  /// Requirement: the only methods that are invoked are states
  @override
  onMethodInvocation(MethodInvocation node) {
    if (node.methodName.toString() == "emit") return '';
    String state = node.methodName.toString();
    methodInvocation.add(state);
    // return state;
  }

  // Extracts the transitions of the cubit
  // Requirement: the only methods that are declared are transitions
  @override
  onMethodDeclaration(MethodDeclaration node) {
    String functionName = node.name.toString();
    Set<String> fromState = {};
    String toState = "";
    Set<bool Function()> conditions = {};
    Set<Function()> inputs = {};

    // Extracts the fromState
    // TODO: extract the fromState denied fromStates from the conditions

    // Extracts the toState
    _RecursiveCubitVisitor recursiveAstVisitor = _RecursiveCubitVisitor(
      onVisitMethodInvocation: (MethodInvocation node) {
        if (node.methodName.toString() == "emit") return;
        toState = node.methodName.toString();
        return toState;
      },
      onVisitMethodDeclaration: (MethodDeclaration node) {},
      onVisitSuperConstructorInvocation: (SuperConstructorInvocation node) {},
    );
    recursiveAstVisitor.visitMethodDeclaration(node);

    //Todo: find conditions
    //Todo: find inputs

    if (toState.isEmpty) {
      throw "Must have ending state";
    }

    methodDeclaration
        .add(Transition(functionName, fromState, toState, conditions, inputs));
  }
}

// Recursive visitor to find states, events, transitions and initial state of a cubit
class _RecursiveCubitVisitor extends RecursiveAstVisitor {
  _RecursiveCubitVisitor({
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
