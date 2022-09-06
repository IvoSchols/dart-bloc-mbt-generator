import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/recursive_cubit_visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';

class EventManager implements EventListener {
  final Set<EventListener> eventListeners;
  late RecursiveAstVisitor recursiveAstVisitor;

  EventManager(this.eventListeners) {
    recursiveAstVisitor = RecursiveCubitVisitor(
      onVisitClassDeclaration: visitClassDeclaration,
      onVisitSuperConstructorInvocation: visitSuperConstructorInvocation,
      onVisitMethodInvocation: visitMethodInvocation,
      onVisitMethodDeclaration: visitMethodDeclaration,
      onVisitSimpleFormalParameter: visitSimpleFormalParameter,
      onVisitIfElement: visitIfElement,
      onVisitSwitchCase: visitSwitchCase,
      onVisitSwitchDefault: visitSwitchDefault,
      onVisitSwitchStatement: visitSwitchStatement,
    );
  }

  // void subscribe(EventListener eventListener) {
  //   if (eventListener is EventManager) {
  //     throw Exception('Cannot subscribe as EventManager');
  //   }
  //   eventListeners.add(eventListener);
  // }

  // void unsubscribe(EventListener eventListener) {
  //   eventListeners.remove(eventListener);
  // }

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

  @override
  visitSimpleFormalParameter(SimpleFormalParameter node) {
    for (EventListener eventListener in eventListeners) {
      eventListener.visitSimpleFormalParameter(node);
    }
  }

  @override
  visitIfElement(IfElement node) {
    for (EventListener eventListener in eventListeners) {
      eventListener.visitIfElement(node);
    }
  }

  @override
  visitSwitchCase(SwitchCase node) {
    for (EventListener eventListener in eventListeners) {
      eventListener.visitSwitchCase(node);
    }
  }

  @override
  visitSwitchDefault(SwitchDefault node) {
    for (EventListener eventListener in eventListeners) {
      eventListener.visitSwitchDefault(node);
    }
  }

  @override
  visitSwitchStatement(SwitchStatement node) {
    for (EventListener eventListener in eventListeners) {
      eventListener.visitSwitchStatement(node);
    }
  }
}
