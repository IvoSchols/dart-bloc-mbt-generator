import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/visitor_decorator.dart';

class StatesDecorator extends VisitorDecorator {
  StatesDecorator(super.wrappee);

  @override
  void onMethodDeclaration(MethodDeclaration node) {
    super.onMethodDeclaration(node);
    // TODO: implement onMethodDeclaration
    throw UnimplementedError();
  }

  @override
  void onMethodInvocation(MethodInvocation node) {
    super.onMethodInvocation(node);
    // TODO: implement onMethodInvocation
    throw UnimplementedError();
  }

  @override
  void onSuperConstructorInvocation(SuperConstructorInvocation node) {
    super.onSuperConstructorInvocation(node);
    // TODO: implement onSuperConstructorInvocation
    throw UnimplementedError();
  }
}
