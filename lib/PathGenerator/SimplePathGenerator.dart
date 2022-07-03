import 'package:statemachine/statemachine.dart';

import 'PathGenerator.dart';

class SimplePathGenerator implements PathGenerator {
  //Generarate simple paths from initial state to all states
  List<Paths> generateAllPaths(Machine finiteStateMachine) {
    List<Paths> paths = [];
    finiteStateMachine.states.forEach((State state) {
      paths.add(this.generatePaths(finiteStateMachine, state));
    });
    return paths;
  }

  @override
  Paths generatePaths(Machine finiteStateMachine, State toState) {
    //Initialize visited states map with false
    Map<State, bool> visited = Map.fromIterable(finiteStateMachine.states,
        key: (state) => state, value: (_) => false);
    Path currentPath = Path([]);
    Paths simplePaths = Paths(toState, []);
    finiteStateMachine.start();
    State? startState = finiteStateMachine.current;
    if (startState == null) {
      throw Exception("No start state");
    }

    _DFS(finiteStateMachine, startState, "", toState, visited, currentPath,
        simplePaths);
    return simplePaths;
  }

  //Generate simple paths from initial state to target state
  dynamic _DFS(
      Machine finiteStateMachine,
      State startState,
      String lastTransition,
      State endState,
      Map<State, bool> visited,
      Path currentPath,
      Paths simplePaths) {
    if (visited[startState] == null)
      throw Exception("Start state not found");
    else if (visited[startState] == true) return;

    visited[startState] = true;
    currentPath.segments.add(Segment(startState, Event(lastTransition)));
    if (startState == endState) {
      simplePaths.paths.add(currentPath.copy());
      visited[startState] = false;
      currentPath.segments.removeLast();
      return;
    }

    //Iterate over all transitions from current state
    for (Transition transition in startState.transitions) {
      //   // State nextState = transition.activate();
      //   if (nextState == startState) continue;
      //   _DFS(finiteStateMachine, nextState, transition.key, endState, visited,
      //       currentPath, simplePaths);
    }
    return simplePaths;
  }
}
