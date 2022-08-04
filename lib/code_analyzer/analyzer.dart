import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:pub_semver/pub_semver.dart';

import 'visitor/cubit_visitor.dart';
import 'package:path/path.dart' as p;

class Analyzer {
//Returns state machine for the given file, or null if no state machine is found
  static dynamic analyzeSingleFile(String path) {
    String absolutePath = p.absolute("lib/$path");
    ParseStringResult parseStringResult = parseFile(
        path: absolutePath,
        featureSet: FeatureSet.fromEnableFlags2(
            flags: [], sdkLanguageVersion: Version.parse('2.16.2')));
    CompilationUnit unit = parseStringResult.unit;

    dynamic result = _checkCompilationUnit(unit);

    if (result == null) return null;

    return result;
  }

  static dynamic _checkCompilationUnit(CompilationUnit unit) {
    //TODO: update with general visitor that discriminates between cubit & bloc
    AstVisitor visitor;
    dynamic dynReturn;

    for (dynamic childEntity in unit.childEntities) {
      //If childEntity is a ClassDeclaration, check if it is a FiniteStateMachineCubit
      //If it is, return a FiniteStateMachineCubit
      if (childEntity is ClassDeclaration &&
          childEntity.extendsClause != null &&
          childEntity.extendsClause!.superclass.name.toString() == "Cubit") {
        visitor = CubitVisitor();
        dynReturn = visitor.visitClassDeclaration(childEntity);

        if (dynReturn != null) break;
      }
    }

    return dynReturn;
  }
}
