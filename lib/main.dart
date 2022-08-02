// @dart=2.9
import 'package:dart_bloc_mbt_generator/path_generator/PathGenerator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/SimplePathGenerator.dart';
import 'package:dart_bloc_mbt_generator/examples/cubit_examples/simpleAB/statemachine/simpleAB_statemachine.dart';
import 'package:state_machine/state_machine.dart';

void main(List<String> args) {
  final StateMachine machine = constructSimpleABStatemachine();

  PathGenerator pathGenerator = SimplePathGenerator();
  List<Paths> allPaths = pathGenerator.generateAllPaths(machine);
  print(allPaths.toString());
  print("hello");
  // machine.newState

  // print(machine.states);
}
