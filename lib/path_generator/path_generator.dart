// ignore: import_of_legacy_library_into_null_safe
import 'package:state_machine/state_machine.dart';

abstract class PathGenerator {
  List<Path> generatePaths(StateMachine finiteStateMachine);
  List<Path> generatePathsTo(StateMachine machine, State toState);
}

//Sequence of segments of a path (always starts with initial state!)
class Path {
  List<Segment> segments;

  Path(this.segments);

  Path copy() => Path(segments.map((segment) => segment.copy()).toList());
}

//Current state and which event will be triggered to get to the next state
class Segment {
  State state;
  Event event;

  Segment(this.state, this.event);

  Segment copy() => Segment(state, event);
}

//Transition
class Event {
  String name;

  Event(this.name);
}
