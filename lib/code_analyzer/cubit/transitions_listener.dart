import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';

class TransitionsListener extends EventListener {
  //TODO: find ways to identify when a transition is found and to build it and add it to the list of transitions when finished
  Transition? currentTransition = null;
  int currentTransitionEnd = -1;

  Set<Transition> transitions = {};

  @override
  void visitClassDeclaration(ClassDeclaration node) {}

  /// The first entry point for finding transitions.
  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    String functionName = node.name.toString();
    Set<String> fromStates = {}; // Set illegal and later subtract from states
    Set<String> toStates = {};
    Set<bool Function()> conditions = {};
    Set<Function()> inputs = {};

    Transition newTransition = Transition(
      functionName,
      fromStates,
      toStates,
      conditions,
      inputs,
    );

    currentTransition = newTransition;
    currentTransitionEnd = node.end;

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

    // transitions
    //     .add(Transition(functionName, fromState, toState, conditions, inputs));
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.toString() == "emit") return;
    if (currentTransition == null) return;
    String toState = node.methodName.toString();
    currentTransition!.toStates.add(toState);

    // Cannot seem to visit end?
    if (currentTransitionEnd == node.end + 2) {
      transitions.add(currentTransition!);
      currentTransition = null;
    }
  }

  @override
  void visitSuperConstructorInvocation(SuperConstructorInvocation node) {}
}
