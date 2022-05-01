import '../FiniteStateMachine/FiniteStateMachineBase.dart';

abstract class PathGenerator {
  //TODO: update the variable type
  dynamic generatePath(
      FiniteStateMachineBase finiteStateMachine, State finalState);
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
}

//Current state and which event will be triggered to get to the next state
class Segment {
  State state;
  Event event;

  Segment(this.state, this.event);
}

//Transition
class Event {
  String name;

  Event(this.name);
}
