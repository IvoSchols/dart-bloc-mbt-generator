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

import 'package:statemachine/statemachine.dart';
import 'Visitor/CubitVisitor.dart';

void analyzeAllFiles(AnalysisContextCollection collection) {
  //TODO: implement like analyzeSomeFiles
  for (AnalysisContext context in collection.contexts) {
    for (String path in context.contextRoot.analyzedFiles()) {
      analyzeSingleFile(context, path);
    }
  }
}

//Returns state machine for the given files, or null if no state machine is found
List<Machine> analyzeSomeFiles(
    AnalysisContextCollection collection, List<String> includedPaths) {
  List<Machine> stateMachines = [];
  for (String path in includedPaths) {
    AnalysisContext context = collection.contextFor(path);
    Machine? stateMachine = analyzeSingleFile(context, path);
    if (stateMachine == null) {
      print("Could not analyze $path");
      continue;
    }
    stateMachines.add(stateMachine);
  }
  return stateMachines;
}

//Returns state machine for the given file, or null if no state machine is found
Machine? analyzeSingleFile(AnalysisContext context, String path) {
  AnalysisSession session = context.currentSession;
  ParseStringResult parseStringResult = parseFile(
      path: path,
      featureSet: FeatureSet.fromEnableFlags2(
          flags: [], sdkLanguageVersion: Version.parse('2.16.2')));
  CompilationUnit unit = parseStringResult.unit;

  print(unit.toString());

  return checkCompilationUnit(unit);
}

void processFile(AnalysisSession session, String path) async {
  var result = session.getParsedUnit(path);
  if (result is ParsedUnitResult) {
    CompilationUnit unit = result.unit;
  }
}

void main() {
  List<String> includedPaths = <String>[
    '/home/steen/Documents/Leiden/BachelorDossier/examples/counter/counter_cubit.dart'
  ];
  AnalysisContextCollection collection =
      new AnalysisContextCollection(includedPaths: includedPaths);
  analyzeSomeFiles(collection, includedPaths);
}

Machine? checkCompilationUnit(CompilationUnit unit) {
  //TODO: update with general visitor that discriminates between cubit & bloc
  AstVisitor visitor;
  Machine? stateMachine;

  for (dynamic child in unit.childEntities) {
    //If childEntity is a ClassDeclaration, check if it is a FiniteStateMachineCubit
    //If it is, return a FiniteStateMachineCubit
    if (child is ClassDeclaration &&
        child.extendsClause != null &&
        child.extendsClause!.superclass.name.toString() == "Cubit") {
      visitor = CubitVisitor();
      stateMachine = visitor.visitClassDeclaration(child);

      if (stateMachine != null) break;
    }
  }
  return stateMachine;
}
