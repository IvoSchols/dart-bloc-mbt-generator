// @dart=2.9
import 'package:dart_bloc_mbt_generator/PathGenerator/PathGenerator.dart';
import 'package:dart_bloc_mbt_generator/PathGenerator/SimplePathGenerator.dart';
import 'package:dart_bloc_mbt_generator/examples/cubit_examples/simpleAB/statemachine/simpleAB_statemachine.dart';
import 'package:state_machine/state_machine.dart';

void main(List<String> args) {
  final machine = constructSimpleABStatemachine();

  PathGenerator pathGenerator = SimplePathGenerator();
  List<Paths> allPaths = pathGenerator.generateAllPaths(machine);
  print(allPaths.toString());
  print("hello");
  // machine.newState

  // print(machine.states);
}
