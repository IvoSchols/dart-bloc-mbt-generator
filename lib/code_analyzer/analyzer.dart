import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/states_decorator.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/transitions_decorator.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/variables_decorator.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/visitor_decorator.dart';
import 'package:pub_semver/pub_semver.dart';

import 'cubit/cubit_visitor.dart';
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

    VisitedCubit result = _checkCompilationUnit(unit);

    return result;
  }

  static VisitedCubit _checkCompilationUnit(CompilationUnit unit) {
    //TODO: update with general visitor that discriminates between cubit & bloc
    VisitedCubit? visitedCubit;

    for (dynamic childEntity in unit.childEntities) {
      //If childEntity is a ClassDeclaration, check if it is a FiniteStateMachineCubit
      //If it is, return a FiniteStateMachineCubit
      if (childEntity is ClassDeclaration &&
          childEntity.extendsClause != null &&
          childEntity.extendsClause!.superclass.name.toString() == "Cubit") {
        CubitVisitor visitor = CubitVisitor();
        StatesDecorator statesDecorator = StatesDecorator(visitor);
        VariablesDecorator variablesDecorator =
            VariablesDecorator(statesDecorator);
        TransitionsDecorator transitionsDecorator =
            TransitionsDecorator(variablesDecorator);

        transitionsDecorator.onClassDeclaration(childEntity);

        String name = visitor.classDeclaration;
        Set<String> states = {};
        Map<String, String> variables = {};
        Set<Transition> transitions = {};
        String startingState = visitor.superclassName;

        //TODO: build visitedCubit from decorators and concrete component
        visitedCubit = VisitedCubit(name, {}, {}, {}, startingState);
      }
    }
    if (visitedCubit == null) throw Exception("No cubit found");

    return visitedCubit;
  }
}
