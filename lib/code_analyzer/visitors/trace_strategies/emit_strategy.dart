import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/trace.dart';

class EmitStrategy extends SimpleAstVisitor {
  late final Trace _currentTrace;

  Trace get currentTrace => _currentTrace;

  EmitStrategy(Trace currentTrace) {
    _currentTrace = currentTrace.copyWith();
  }

  // Assume equals emit check is done by the caller
  @override
  void visitMethodInvocation(MethodInvocation node) {
    String toState = (node.argumentList.arguments[0] as MethodInvocation)
        .methodName
        .toString();

    _currentTrace.toState = toState;
  }
}
