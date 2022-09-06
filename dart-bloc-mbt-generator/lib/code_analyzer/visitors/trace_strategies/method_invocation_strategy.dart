import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/traces_visitor.dart';

class MethodInvocationStrategy extends SimpleAstVisitor {
  late final Trace _currentTrace;

  get currentTrace => _currentTrace;

  MethodInvocationStrategy(Trace currentTrace) {
    _currentTrace = currentTrace.copyWith();
  }

  // Emit()
  @override
  void visitMethodInvocation(MethodInvocation node) {
    String toState = node.methodName.toString();

    // assert(!_currentTraceNode!.hasChildren(), "Node cannot have children");

    _currentTrace.toState = toState;
  }
}
