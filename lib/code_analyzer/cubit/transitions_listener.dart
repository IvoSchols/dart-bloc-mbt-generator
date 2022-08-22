import 'dart:collection';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';

class TransitionsListener extends EventListener {
  //TODO: find ways to identify when a transition is found and to build it and add it to the list of transitions when finished
  Transition? currentTransition;
  int currentTransitionEnd = -1;

  Set<Transition> transitions = {};

  @override
  void visitClassDeclaration(ClassDeclaration node) {}

  /// The first entry point for finding transitions.
  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    String functionName = node.name.toString();
    Set<String> illegalFromStates = {};
    Set<String> fromStates = {}; // Set illegal and later subtract from states
    String toState = "";
    Set<String> conditions = {};
    LinkedHashMap<String, String> inputs = LinkedHashMap();

    Transition newTransition = Transition(
      functionName,
      illegalFromStates,
      fromStates,
      toState,
      conditions,
      inputs,
    );

    currentTransition = newTransition;
    currentTransitionEnd = node.end;
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.toString() == "emit") return;
    if (currentTransition == null) return;
    String toState = node.methodName.toString();
    currentTransition = currentTransition!.copyWith(toState: toState);

    // Cannot seem to visit end? -> TODO: magic number

    // _tryToCloseTransition(node.parent!.end + 1);
    //Cannot invoke other methods because I do not know how end works
    transitions.add(currentTransition!);
    currentTransition = null;
    currentTransitionEnd = -1;
  }

  // _tryToCloseTransition(int end) {
  //   if (currentTransitionEnd == -1) return;
  //   if (currentTransitionEnd == end) {
  //     transitions.add(currentTransition!);
  //     currentTransition = null;
  //     currentTransitionEnd = -1;
  //   }
  // }

  // Read conditions of the transition/method
  @override
  void visitSimpleFormalParameter(SimpleFormalParameter node) {
    if (currentTransition == null) return;
    String name = node.identifier.toString();

    if (currentTransition!.inputs.containsKey(name)) {
      throw "Input name already exists";
    }

    String type = node.type.toString();

    currentTransition!.inputs[name] = type;
  }

  @override
  void visitIfElement(IfElement node) {
    if (currentTransition == null) return;
    String condition = node.condition.toString();
    currentTransition!.conditions.add(condition);
    // _tryToCloseTransition(node.parent!.end + 1);
  }
}
