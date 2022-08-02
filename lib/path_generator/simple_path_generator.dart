import 'package:state_machine/state_machine.dart';

import 'PathGenerator.dart';

class SimplePathGenerator implements PathGenerator {
  //Generarate simple paths from initial state to all states
  @override
  List<Paths> generateAllPaths(StateMachine stateMachine) {
    List<Paths> paths = [];
    List<State> states = stateMachine.states;
    for (State state in states) {
      paths.add(generatePaths(stateMachine, state));
    }
    return paths;
  }

  @override
  Paths generatePaths(StateMachine finiteStateMachine, State toState) {
    //Initialize visited states map with false
    Map<State, bool> visited = {
      for (var state in finiteStateMachine.states) state: false
    };
    Path currentPath = Path([]);
    Paths simplePaths = Paths(toState, []);
    // finiteStateMachine.start();
    State? startState = finiteStateMachine.current;
    if (startState == null) {
      throw Exception("No start state");
    }

    _dfs(finiteStateMachine, startState, "", toState, visited, currentPath,
        simplePaths);
    return simplePaths;
  }

  //Generate simple paths from initial state to target state
  dynamic _dfs(
      StateMachine finiteStateMachine,
      State startState,
      String lastTransition,
      State endState,
      Map<State, bool> visited,
      Path currentPath,
      Paths simplePaths) {
    if (visited[startState] == null) {
      throw Exception("Start state not found");
    } else if (visited[startState] == true) {
      return;
    }

    visited[startState] = true;
    currentPath.segments.add(Segment(startState, Event(lastTransition)));
    if (startState == endState) {
      simplePaths.paths.add(currentPath.copy());
      visited[startState] = false;
      currentPath.segments.removeLast();
      return;
    }

    //Iterate over all transitions from current state
    for (StateTransition transition in startState.transitions) {
      State nextState = transition.to;
      if (nextState == startState) continue;
      _dfs(finiteStateMachine, nextState, transition.name, endState, visited,
          currentPath, simplePaths);
    }
    return simplePaths;
  }
}
