import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/trace.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/trace_strategies/method_declaration_strategy.dart';

class TracesVisitor extends SimpleAstVisitor {
  final Set<Trace> traces = {};

  /// The first entry point for finding transitions.
  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    MethodDeclarationStrategy strategy = MethodDeclarationStrategy();
    strategy.visitMethodDeclaration(node);
    traces.addAll(strategy.traces);
  }
}
