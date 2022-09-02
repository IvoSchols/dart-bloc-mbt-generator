import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/listeners/name_listener.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/listeners/states_listener.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/listeners/transitions_listener.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/listeners/variables_listener.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_manager.dart';
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
        StatesListener statesListener = StatesListener();
        TracesListener tracesListener = TracesListener();
        VariablesListener variablesListener = VariablesListener();
        NameListener nameListener = NameListener();

        EventManager eventManager = EventManager({
          statesListener,
          tracesListener,
          variablesListener,
          nameListener,
        });

        eventManager.recursiveAstVisitor.visitClassDeclaration(childEntity);

        String name;
        Set<String> states = {};
        // Map<String, String> variables = {};
        // Set<Transition> transitions = {};
        String startingState;

        // Name of the cubit
        if (nameListener.name.isEmpty) {
          throw Exception("No cubit name found");
        }
        name = nameListener.name;
        stateMachine = StateMachine(name);

        // Name of the starting state
        if (statesListener.startingState.isEmpty) {
          throw Exception("No superclass found");
        }
        startingState = statesListener.startingState;
        stateMachine.newState(startingState);

        // States of the cubit
        if (statesListener.states.isEmpty) {
          throw Exception("No states found");
        }
        states = statesListener.states;
        Map<String, State> stateMap = {};

        for (String state in states) {
          stateMap[state] = stateMachine.newState(state);
        }

        // Context Variables of the cubit
        // if (variablesListener.variables.isEmpty) {
        //   throw Exception("No method invocation found");
        // }

        // Transitions of the cubit
        if (tracesListener.traces.isEmpty) {
          throw Exception("No method declaration is found");
        }
        //Convert trace trees to transitions
        for (Trace trace in tracesListener.traces) {
          stateMachine.newTransition(
              trace.functionName,
              states
                  .difference(trace.illegalFromStates)
                  .map((string) => stateMap[string]!)
                  .toSet(),
              stateMap[trace.toState]!,
              conditions: {
                'inputTypes': trace.inputTypes,
                'conditionTree': trace.conditionTree
              });
        }
      }
    }
    if (stateMachine == null) throw Exception("No cubit found");

    return stateMachine;
  }
}