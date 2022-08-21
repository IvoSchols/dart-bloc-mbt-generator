import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';

class TransitionsListener extends EventListener {
  //TODO: find ways to identify when a transition is found and to build it and add it to the list of transitions when finished
  Transition? currentTransition = null;

  Set<Transition> transitions = {};

  @override
  void visitClassDeclaration(ClassDeclaration node) {}

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    String functionName = node.name.toString();
    Set<String> fromState = {};
    String toState = "";
    Set<bool Function()> conditions = {};
    Set<Function()> inputs = {};

    // Extracts the fromState
    // TODO: extract the fromState denied fromStates from the conditions

    // Extracts the toState
    // _RecursiveCubitVisitor recursiveAstVisitor = _RecursiveCubitVisitor(
    //   onVisitMethodInvocation: (MethodInvocation node) {
    //     if (node.methodName.toString() == "emit") return;
    //     toState = node.methodName.toString();
    //     return toState;
    //   },
    //   onVisitMethodDeclaration: (MethodDeclaration node) {},
    //   onVisitSuperConstructorInvocation: (SuperConstructorInvocation node) {},
    // );
    // recursiveAstVisitor.visitMethodDeclaration(node);

    //Todo: find conditions
    //Todo: find inputs

    // if (toState.isEmpty) {
    //   throw "Must have ending state";
    // }

    transitions
        .add(Transition(functionName, fromState, toState, conditions, inputs));
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {}

  @override
  void visitSuperConstructorInvocation(SuperConstructorInvocation node) {}
}
