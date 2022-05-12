import '../FiniteStateMachine/FiniteStateMachineBase.dart';
import 'PathGenerator.dart';

class SimplePathGenerator implements PathGenerator {
  //Generarate simple paths from initial state to all states
  List<Paths> generateAllPaths(FiniteStateMachineBase finiteStateMachine) {
    List<Paths> paths = [];
    finiteStateMachine.states.forEach((State state) {
      paths.add(this.generatePaths(finiteStateMachine, state));
    });
    return paths;
  }

  @override
  Paths generatePaths(
      FiniteStateMachineBase finiteStateMachine, State finalState) {
    //Initialize visited states map with false
    Map<State, bool> visited = Map.fromIterable(finiteStateMachine.states,
        key: (state) => state, value: (_) => false);
    Path currentPath = Path([]);
    Paths simplePaths = Paths(finalState, []);
    _DFS(finiteStateMachine, finiteStateMachine.initialState, "", finalState,
        visited, currentPath, simplePaths);
    return simplePaths;
  }

  //Generate simple paths from initial state to target state
  dynamic _DFS(
      FiniteStateMachineBase finiteStateMachine,
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
    for (MapEntry<String, State> transition in startState.transitions.entries) {
      State nextState = transition.value;
      if (nextState == startState) continue;
      _DFS(finiteStateMachine, nextState, transition.key, endState, visited,
          currentPath, simplePaths);
    }
    return simplePaths;
  }
}
