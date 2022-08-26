// ignore: import_of_legacy_library_into_null_safe
import 'package:state_machine/state_machine.dart';

import 'path_generator.dart';

class SimplePathGenerator implements PathGenerator {
  //Generarate simple paths from initial state to all states
  @override
  List<Path> generatePaths(StateMachine stateMachine) {
    List<Path> paths = [];
    for (State state in stateMachine.states) {
      paths.addAll(generatePathsTo(stateMachine, state));
    }
    return paths;
  }

  @override
  List<Path> generatePathsTo(StateMachine machine, State toState) {
    //Initialize visited states map with false
    Map<State, bool> visited = {for (var state in machine.states) state: false};
    Path currentPath = Path([]);
    List<Path> simplePaths = [];
    // finiteStateMachine.start();
    State? startState = machine.current;

    _dfs(machine, startState, "", toState, visited, currentPath, simplePaths);
    return simplePaths;
  }

  //Generate simple paths from initial state to target state
  dynamic _dfs(
      StateMachine machine,
      State startState,
      String lastTransition,
      State endState,
      Map<State, bool> visited,
      Path currentPath,
      List<Path> simplePaths) {
    if (visited[startState] == null) {
      throw Exception("Start state not found");
    } else if (visited[startState] == true) {
      return;
    }

    visited[startState] = true;
    currentPath.segments.add(Segment(startState, Event(lastTransition)));
    if (startState == endState) {
      simplePaths.add(currentPath.copy());
      visited[startState] = false;
      currentPath.segments.removeLast();
      return;
    }

    //Iterate over all transitions from current state
    for (Transition transition in startState.transitions) {
      State nextState = transition.to;
      if (nextState == startState) continue;
      _dfs(machine, nextState, transition.name, endState, visited, currentPath,
          simplePaths);
    }
    return simplePaths;
  }
}
