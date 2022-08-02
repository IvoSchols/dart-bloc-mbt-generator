import 'package:state_machine/state_machine.dart';

abstract class PathGenerator {
  List<Paths> generateAllPaths(StateMachine finiteStateMachine);
  //TODO: update the variable type
  Paths generatePaths(StateMachine finiteStateMachine, State toState);
}

//All the paths from initial state to target state
class Paths {
  State targetState;
  List<Path> paths;

  Paths(this.targetState, this.paths);
}

//Sequence of segments of a path (always starts with initial state!)
class Path {
  List<Segment> segments;

  Path(this.segments);

  Path copy() => Path(this.segments.map((segment) => segment.copy()).toList());
}

//Current state and which event will be triggered to get to the next state
class Segment {
  State state;
  Event event;

  Segment(this.state, this.event);

  Segment copy() => Segment(this.state, this.event);
}

//Transition
class Event {
  String name;
  //TODO?: add a list of guards

  Event(this.name);
}