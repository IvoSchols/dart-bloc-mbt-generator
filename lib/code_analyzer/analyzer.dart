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
import 'package:dart_bloc_mbt_generator/code_analyzer/state_transition_tree/state_transition_tree.dart';
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
    StateMachine? visitedCubitStateMachine;

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
        visitedCubitStateMachine = StateMachine(name);

        // States of the cubit
        if (statesListener.states.isEmpty) {
          throw Exception("No states found");
        }
        states = statesListener.states;
        Map<String, State> statesMap = {};
        for (var state in states) {
          statesMap[state] = visitedCubitStateMachine.newState(state);
        }

        // Context Variables of the cubit
        // if (variablesListener.variables.isEmpty) {
        //   throw Exception("No method invocation found");
        // }

        // Transitions of the cubit
        if (transitionsListener.stateTransitionTrees.isEmpty) {
          throw Exception("No method declaration is found");
        }

        transitions = _buildTransitionsFromTrees(
            transitionsListener.stateTransitionTrees, states);
        // for (Transition transition in transitions) {
        //   Set<String> allowedFromStates =
        //       states.difference(transition.illegalFromStates);
        //   transition.fromStates.addAll(allowedFromStates);
        // }
        // Set<Transition> newTransitions = {};
        // for (var element in transitions) {
        //   newTransitions.add(element);
        // }
        // transitions = newTransitions;

        for (var transition in transitions) {
          StateTransition st = visitedCubitStateMachine.newStateTransition(
              transition.functionName,
              transition.fromStates.map((f) => statesMap[f]).toList(),
              statesMap[transition.toState]);

          for (var condition in transition.conditions) {
            st.cancelIf(condition); // TODO: finish  this
          }
        }

        // Name of the starting state
        if (nameListener.startingState.isEmpty) {
          throw Exception("No superclass found");
        }
        startingState = nameListener.startingState;

        // VisitedCubit(name, states, variables, transitions, startingState);
      }
    }
    if (visitedCubitStateMachine == null) throw Exception("No cubit found");

    return visitedCubitStateMachine;
  }

  static Set<Transition> _buildTransitionsFromTrees(
      Set<StateTransitionTree> stateTransitionTrees, Set<String> states) {
    Set<Transition> transitions = {};

    for (StateTransitionTree tree in stateTransitionTrees) {
      transitions.addAll(_buildTransitionsFromTree(tree, states));
    }

    return transitions;
  }

  // Perform DFS on the state transition tree to find all the transitions
  // and add them to the transitions set
  static Set<Transition> _buildTransitionsFromTree(
      StateTransitionTree stateTransitionTree, Set<String> states) {
    Set<Transition> transitions = {};

    return transitions;
  }
}
