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

import 'Visitor/CubitVisitor.dart';
import '../FiniteStateMachine/FiniteStateMachineCubit.dart';

void analyzeAllFiles(AnalysisContextCollection collection) {
  for (AnalysisContext context in collection.contexts) {
    for (String path in context.contextRoot.analyzedFiles()) {
      analyzeSingleFile(context, path);
    }
  }
}

void analyzeSomeFiles(
    AnalysisContextCollection collection, List<String> includedPaths) {
  for (String path in includedPaths) {
    AnalysisContext context = collection.contextFor(path);
    analyzeSingleFile(context, path);
  }
}

void analyzeSingleFile(AnalysisContext context, String path) {
  AnalysisSession session = context.currentSession;
  ParseStringResult parseStringResult = parseFile(
      path: path,
      featureSet: FeatureSet.fromEnableFlags2(
          flags: [], sdkLanguageVersion: Version.parse('2.16.2')));
  CompilationUnit unit = parseStringResult.unit;

  print(unit.toString());

  checkCompilationUnit(unit);
}

void processFile(AnalysisSession session, String path) async {
  var result = session.getParsedUnit(path);
  if (result is ParsedUnitResult) {
    CompilationUnit unit = result.unit;
  }
}

void main() {
  List<String> includedPaths = <String>[
    '/home/steen/Documents/BachelorDossier/examples/counter/counter_cubit.dart'
  ];
  AnalysisContextCollection collection =
      new AnalysisContextCollection(includedPaths: includedPaths);
  analyzeSomeFiles(collection, includedPaths);
}

String checkCompilationUnit(CompilationUnit unit) {
  //TODO: update with general visitor that discriminates between cubit & bloc
  AstVisitor visitor;

  unit.childEntities.forEach((childEntity) {
    //If childEntity is a ClassDeclaration, check if it is a FiniteStateMachineCubit
    //If it is, return a FiniteStateMachineCubit
    if (childEntity is ClassDeclaration &&
        childEntity.extendsClause != null &&
        childEntity.extendsClause!.superclass.name.toString() == "Cubit") {
      visitor = CubitVisitor();
      FiniteStateMachineCubit? fsmCubit =
          visitor.visitClassDeclaration(childEntity);

      if (fsmCubit != null) {
        fsmCubit.export(fsmCubit.name + ".json");
      }
    }
  });

  return "visitor.result";
}
