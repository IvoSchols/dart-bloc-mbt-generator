import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';

class NameListener extends EventListener {
  String name = "";
  String startingState = "";

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (node.extendsClause == null ||
        node.extendsClause!.superclass.name.toString() != "Cubit") {
      throw Exception("Not a Cubit class");
    }
    if (name.isNotEmpty) {
      throw Exception("Multiple class declarations found");
    }
    name = node.name.toString();
    name = name.replaceFirst(RegExp("cubit|Cubit"), '', name.length - 5);
  }

  @override
  void visitSuperConstructorInvocation(SuperConstructorInvocation node) {
    if (startingState.isNotEmpty) {
      throw Exception("Multiple superclasses found");
    }
    startingState =
        node.argumentList.arguments.first.childEntities.first.toString();
  }
}
