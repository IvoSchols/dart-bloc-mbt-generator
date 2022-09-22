import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/trace.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/traces_visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/variables_visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/name_visitor.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitors/states_visitor.dart';
import 'package:pub_semver/pub_semver.dart';

import 'package:path/path.dart' as p;
import 'package:state_machine/state_machine.dart';

class Analyzer {
//Returns state machine for the given file, or null if no state machine is found
  static dynamic analyzeSingleFile(String path) {
    String absolutePath = p.absolute("lib/$path");
    ParseStringResult parseStringResult = parseFile(
        path: absolutePath,
        featureSet: FeatureSet.fromEnableFlags2(
            flags: [], sdkLanguageVersion: Version.parse('2.16.2')));
    CompilationUnit unit = parseStringResult.unit;

    StateMachine result = _checkCompilationUnit(unit);

    return result;
  }

  static StateMachine _checkCompilationUnit(CompilationUnit unit) {
    //TODO: update with general visitor that discriminates between cubit & bloc
    StateMachine? stateMachine;

    for (dynamic childEntity in unit.childEntities) {
      //If childEntity is a ClassDeclaration, check if it is a FiniteStateMachineCubit
      //If it is, return a FiniteStateMachineCubit
      if (childEntity is ClassDeclaration &&
          childEntity.extendsClause != null &&
          childEntity.extendsClause!.superclass.name.toString() == "Cubit") {
        StatesVisitor statesVisitor = StatesVisitor();
        TracesVisitor tracesVisitor = TracesVisitor();
        VariablesVisitor variablesVisitor = VariablesVisitor();
        NameVisitor nameVisitor = NameVisitor();

        DelegatingAstVisitor delegatingCubitVisitor = DelegatingAstVisitor(
            {statesVisitor, tracesVisitor, variablesVisitor, nameVisitor});

        delegatingCubitVisitor.visitClassDeclaration(childEntity);

        String name;
        Set<String> states = {};
        // Map<String, String> variables = {};
        String initialState;

        // Name of the cubit
        if (nameVisitor.name.isEmpty) {
          throw Exception("No cubit name found");
        }
        name = nameVisitor.name;
        stateMachine = StateMachine(name);

        // Name of the starting state
        if (statesVisitor.initialState.isEmpty) {
          throw Exception("No superclass found");
        }
        initialState = statesVisitor.initialState;
        stateMachine.newState(initialState);

        // States of the cubit
        if (statesVisitor.states.isEmpty) {
          throw Exception("No states found");
        }
        states = statesVisitor.states;
        Map<String, State> stateMap = {};

        bool exceptionStateExists = false;

        for (String state in states) {
          stateMap[state] = stateMachine.newState(state);
          if (state == "Exception") {
            exceptionStateExists = true;
          }
        }

        // Context Variables of the cubit
        // if (variablesListener.variables.isEmpty) {
        //   throw Exception("No method invocation found");
        // }

        // Transitions of the cubit
        if (tracesVisitor.traces.isEmpty) {
          throw Exception("No method declaration is found");
        }
        //Convert trace trees to transitions
        for (Trace trace in tracesVisitor.traces) {
          assert(trace.currentNode == null);

          Map<dynamic, dynamic>? conditions = {};
          if (trace.inputTypes.isNotEmpty) {
            conditions['inputTypes'] = trace.inputTypes;
          }
          if (trace.conditionTree.root != null) {
            conditions['conditionTree'] = trace.conditionTree;
          }
          if (conditions.isEmpty) {
            conditions = null;
          }
          if (exceptionStateExists) {
            trace.illegalFromStates.add("Exception");
          }

          stateMachine.newTransition(
              trace.functionName,
              states
                  .difference(trace.illegalFromStates)
                  .map((string) => stateMap[string]!)
                  .toSet(),
              stateMap[trace.toState]!,
              conditions: conditions);
        }
      }
    }
    if (stateMachine == null) throw Exception("No cubit found");

    return stateMachine;
  }
}
