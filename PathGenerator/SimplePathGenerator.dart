import '../FiniteStateMachine/FiniteStateMachineBase.dart';
import 'PathGenerator.dart';

class SimplePathGenerator implements PathGenerator {
  //Generarate simple paths from initial state to all states
  List<dynamic> generatePaths(FiniteStateMachineBase finiteStateMachine) {
    List<dynamic> paths = [];
    finiteStateMachine.states.forEach((state) {
      paths.add(this.generatePath(finiteStateMachine, state));
    });
    return paths;
  }

  @override
  dynamic generatePath(
      FiniteStateMachineBase finiteStateMachine, State finalState) {
    Map<String, bool> visited = finiteStateMachine.states
        .map((e) => MapEntry(e, false)) as Map<String, bool>;
    List<dynamic> currentPath = [];
    List<dynamic> simplePath = [];

    var DFS = (String startState, String endState) {
      if (visited[startState] == null)
        throw Exception("Start state not found");
      else if (visited[startState] == true) return;

      visited[startState] = true;
      currentPath.add(startState);
      if (startState == endState) {
        simplePath = currentPath;
        return;
      }
      for (var nextState
          in finiteStateMachine.states[currentState].nextStates) {
        if (!visited[nextState]) {
          DFS(nextState);
        }
      }
      currentPath.removeLast();
    };

    DFS(
      finiteStateMachine.initialState,
    );

    return simplePath;
  }
}
