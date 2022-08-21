import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';

class EventManager implements EventListener {
  Set<EventListener> eventListeners = {};
  late RecursiveAstVisitor recursiveAstVisitor;

  EventManager() {
    recursiveAstVisitor = RecursiveCubitVisitor(
      onVisitClassDeclaration: visitClassDeclaration,
      onVisitSuperConstructorInvocation: visitSuperConstructorInvocation,
      onVisitMethodInvocation: visitMethodInvocation,
      onVisitMethodDeclaration: visitMethodDeclaration,
    );
  }

  void subscribe(EventListener eventListener) {
    if (eventListener is EventManager) {
      throw Exception('Cannot subscribe as EventManager');
    }
    eventListeners.add(eventListener);
  }

  void unsubscribe(EventListener eventListener) {
    eventListeners.remove(eventListener);
  }

  /// Extracts the name of the class (and removes the 'Cubit' suffix)
  /// Requirement: class name must not be 'empty' (i.e. no name)
  @override
  visitClassDeclaration(ClassDeclaration node) {
    for (EventListener eventListener in eventListeners) {
      eventListener.visitClassDeclaration(node);
    }
  }

  /// Extracts the name of the superclass
  @override
  visitSuperConstructorInvocation(SuperConstructorInvocation node) {
    for (EventListener eventListener in eventListeners) {
      eventListener.visitSuperConstructorInvocation(node);
    }
  }

  @override
  visitMethodInvocation(MethodInvocation node) {
    for (EventListener eventListener in eventListeners) {
      eventListener.visitMethodInvocation(node);
    }
  }

  // Extracts the transitions of the cubit
  // Requirement: the only methods that are declared are transitions
  @override
  visitMethodDeclaration(MethodDeclaration node) {
    for (EventListener eventListener in eventListeners) {
      eventListener.visitMethodDeclaration(node);
    }
  }
}
