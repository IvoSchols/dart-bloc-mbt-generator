import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/traces_visitor.dart';

class SwitchStrategy extends SimpleAstVisitor {
  SwitchStrategy(Trace currentTrace) {
    _currentTrace = currentTrace.copyWith();
  }

  late final Trace _currentTrace;

  @override
  void visitSwitchCase(SwitchCase node) {}

  @override
  void visitSwitchDefault(SwitchDefault node) {}

  @override
  void visitSwitchStatement(SwitchStatement node) {}
}
