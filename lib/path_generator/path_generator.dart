import 'package:simple_state_machine/state_machine.dart';

abstract class PathGenerator {
  List<Path> generatePaths(StateMachine finiteStateMachine);
  List<Path> generatePathsTo(StateMachine machine, State toState);
}

//Sequence of segments of a path (always starts with initial state!)
class Path {
  List<Map<String, String>> pathInputs;
  List<Transition> transitions;

  Path(this.pathInputs, this.transitions);
}
