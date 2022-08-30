import 'package:state_machine/state_machine.dart';

abstract class PathGenerator {
  List<Path> generatePaths(StateMachine finiteStateMachine);
  List<Path> generatePathsTo(StateMachine machine, State toState);
}

//Sequence of segments of a path (always starts with initial state!)
class Path {
  Map<String, String> pathInput;
  List<Transition> transitions;

  Path(this.pathInput, this.transitions);
}
