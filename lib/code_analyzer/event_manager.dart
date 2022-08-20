import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';
import 'package:equatable/equatable.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:state_machine/state_machine.dart';

class EventManager implements EventListener {
  Set<EventListener> eventListeners = {};
  late RecursiveAstVisitor recursiveAstVisitor;

  EventManager() {
    recursiveAstVisitor = RecursiveCubitVisitor(
      onVisitClassDeclaration: onClassDeclaration,
      onVisitSuperConstructorInvocation: onSuperConstructorInvocation,
      onVisitMethodInvocation: onMethodInvocation,
      onVisitMethodDeclaration: onMethodDeclaration,
    );
  }

  void subscribe(EventListener eventListener) {
    if (eventListener is EventManager) {
      throw Exception('Cannot subscribe as EventManager');
    }
    if (eventListeners.contains(eventListener)) {
      throw Exception('Already subscribed');
    }
    eventListeners.add(eventListener);
  }

  void unsubscribe(EventListener eventListener) {
    if (!eventListeners.contains(eventListener)) {
      throw Exception('Not subscribed');
    }
    eventListeners.remove(eventListener);
  }

  void notify(Function event, var data) {
    //TODO: notify all event listeners by calling their own event methods

    eventListeners.forEach((eventListener) {
      eventListener(event, data);
    });
    eventListeners.forEach(event(data));
  }

  /// Extracts the name of the class (and removes the 'Cubit' suffix)
  /// Requirement: class name must not be 'empty' (i.e. no name)
  @override
  onClassDeclaration(ClassDeclaration node) {
    notify(onClassDeclaration, node);
    // recursiveAstVisitor.visitClassDeclaration(node);
  }

  /// Extracts the name of the superclass
  @override
  onSuperConstructorInvocation(SuperConstructorInvocation node) {
    notify(onSuperConstructorInvocation, node);
    // recursiveAstVisitor.visitSuperConstructorInvocation(node);
  }

  @override
  onMethodInvocation(MethodInvocation node) {
    notify(onMethodInvocation, node);
    // recursiveAstVisitor.visitMethodInvocation(node);
  }

  // Extracts the transitions of the cubit
  // Requirement: the only methods that are declared are transitions
  @override
  onMethodDeclaration(MethodDeclaration node) {
    notify(onMethodDeclaration, node);
    // recursiveAstVisitor.visitMethodDeclaration(node);
  }
}
