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
    Path currentPath = Path([], []);
    List<Path> simplePaths = [];

    _dfs(machine, null, toState, visited, currentPath, simplePaths);
    return simplePaths;
  }

  //Generate simple paths from initial state to target state
  dynamic _dfs(StateMachine machine, Transition? transition, State endState,
      Map<State, bool> visited, Path currentPath, List<Path> simplePaths) {
    if (visited[machine.current] == null) {
      throw Exception("Start state not found");
    } else if (visited[machine.current] == true) {
      return;
    }

    visited[machine.current] = true;
    if (transition != null) currentPath.transitions.add(transition);
    if (machine.current == endState) {
      simplePaths.add(currentPath);
      visited[machine.current] = false;
      currentPath.transitions.removeLast();
      return;
    }

    //Iterate over all transitions from current state
    // for (Transition transition in startState.transitions) {
    //   State nextState = transition.to;
    //   if (nextState == startState) continue;
    //   _dfs(machine, nextState, transition.name, endState, visited, currentPath,
    //       simplePaths);
    // }
    return simplePaths;
  }
}
