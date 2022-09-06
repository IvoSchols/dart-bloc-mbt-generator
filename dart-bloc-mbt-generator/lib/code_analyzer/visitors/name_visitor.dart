import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class NameVisitor extends SimpleAstVisitor {
  String name = "";

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (node.extendsClause == null ||
        node.extendsClause!.superclass.name.toString() != "Cubit") {
      throw Exception("Not a Cubit class");
    }
    if (name.isNotEmpty) {
      throw Exception("Multiple class declarations found");
    }
    name = node.name2.toString();
    name = name.replaceFirst(RegExp("cubit|Cubit"), '', name.length - 5);
  }
}
