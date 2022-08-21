import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/name_listener.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/states_listener.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/transitions_listener.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/variables_listener.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_manager.dart';
import 'package:pub_semver/pub_semver.dart';

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
        RecursiveCubitVisitor visitor;

        EventManager eventManager = EventManager();
        StatesListener statesListener = StatesListener();
        TransitionsListener transitionsListener = TransitionsListener();
        VariablesListener variablesListener = VariablesListener();
        NameListener nameListener = NameListener();

        eventManager.subscribe(statesListener);
        eventManager.subscribe(transitionsListener);
        eventManager.subscribe(variablesListener);
        eventManager.subscribe(nameListener);

        eventManager.recursiveAstVisitor.visitClassDeclaration(childEntity);

        String name;
        Set<String> states = {};
        Map<String, String> variables = {};
        Set<Transition> transitions = {};
        String startingState;

        // Name of the cubit
        if (nameListener.name.isEmpty) {
          throw Exception("No cubit name found");
        }
        name = nameListener.name;

        // States of the cubit
        if (statesListener.states.isEmpty) {
          throw Exception("No states found");
        }
        states = statesListener.states;

        // Context Variables of the cubit
        // if (variablesListener.variables.isEmpty) {
        //   throw Exception("No method invocation found");
        // }

        // Transitions of the cubit
        if (transitionsListener.transitions.isEmpty) {
          throw Exception("No method declaration is found");
        }
        transitions = transitionsListener.transitions;
        for (Transition transition in transitions) {
          transition.fromStates = states.difference(transition.fromStates);
        }
        // Name of the starting state
        if (nameListener.startingState.isEmpty) {
          throw Exception("No superclass found");
        }
        startingState = nameListener.startingState;

        visitedCubit =
            VisitedCubit(name, states, variables, transitions, startingState);
      }
    }
    if (visitedCubit == null) throw Exception("No cubit found");

    return visitedCubit;
  }
}
