import 'FiniteStateMachine.dart';

abstract class FiniteStateMachineParser {
  FiniteStateMachine parse(List<String> lines);
}
