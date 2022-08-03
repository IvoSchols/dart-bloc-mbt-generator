import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/ast/precedence.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/src/dart/ast/token.dart';
import 'package:analyzer/src/dart/ast/utilities.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:state_machine/state_machine.dart';

import 'visitor/cubit_visitor.dart';
import 'package:path/path.dart' as p;

class Analyzer {
// void analyzeAllFiles(AnalysisContextCollection collection) {
//   //TODO: implement like analyzeSomeFiles
//   for (AnalysisContext context in collection.contexts) {
//     for (String path in context.contextRoot.analyzedFiles()) {
//       analyzeSingleFile(context, path);
//     }
//   }
// }

//Returns state machine for the given files, or null if no state machine is found
  // List<StateMachine> analyzeSomeFiles(
  //     AnalysisContextCollection collection, List<String> includedPaths) {
  //   List<StateMachine> stateMachines = [];
  //   for (String path in includedPaths) {
  //     AnalysisContext context = collection.contextFor(path);
  //     StateMachine? stateMachine = analyzeSingleFile(context, path);
  //     if (stateMachine == null) {
  //       print("Could not analyze $path");
  //       continue;
  //     }
  //     stateMachines.add(stateMachine);
  //   }
  //   return stateMachines;
  // }

//Returns state machine for the given file, or null if no state machine is found
  static dynamic analyzeSingleFile(String path) {
    String absolutePath = p.absolute("lib/" + path);
    ParseStringResult parseStringResult = parseFile(
        path: absolutePath,
        featureSet: FeatureSet.fromEnableFlags2(
            flags: [], sdkLanguageVersion: Version.parse('2.16.2')));
    CompilationUnit unit = parseStringResult.unit;

    dynamic result = _checkCompilationUnit(unit);

    if (result == null) return null;

    return result;
  }

  // void processFile(AnalysisSession session, String path) async {
  //   var result = session.getParsedUnit(path);
  //   if (result is ParsedUnitResult) {
  //     CompilationUnit unit = result.unit;
  //   }
  // }

// void main() {
//   List<String> includedPaths = <String>[
//     '/home/steen/Documents/Leiden/BachelorDossier/lib/examples/door/door_bloc.dart'
//   ];
//   AnalysisContextCollection collection =
//       new AnalysisContextCollection(includedPaths: includedPaths);
//   analyzeSomeFiles(collection, includedPaths);
// }

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
