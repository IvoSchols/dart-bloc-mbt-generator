import '../FiniteStateMachine/FiniteStateMachineBase.dart';

abstract class PathGenerator {
  List<String> generatePath(FiniteStateMachineBase finiteStateMachine);
}
