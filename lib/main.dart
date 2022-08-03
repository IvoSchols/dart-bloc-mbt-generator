// @dart=2.9
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/simple_path_generator.dart';
import 'package:dart_bloc_mbt_generator/examples/cubit_examples/simple_ab/statemachine/simple_ab_statemachine.dart';
import 'package:dart_bloc_mbt_generator/test_generator/test_generator.dart';
import 'package:state_machine/state_machine.dart';
import 'examples/cubit_examples/simple_ab/cubit/simple_ab_cubit.dart';
// void main(List<String> args) {
//   final StateMachine machine = constructSimpleABStatemachine();

//   PathGenerator pathGenerator = SimplePathGenerator();
//   List<Paths> allPaths = pathGenerator.generateAllPaths(machine);
//   print(allPaths.toString());
//   print("hello");
//   // machine.newState

//   // print(machine.states);
// }

Future<void> main() async {
  String relativePath =
      'examples/cubit_examples/simple_ab/cubit/simple_ab_cubit.dart';

  final StateMachine machine = constructSimpleABStatemachine();
  TestGenerator testGenerator = TestGenerator(relativePath, machine);
  final PathGenerator pathGenerator = SimplePathGenerator();
  final List<Paths> allPaths = pathGenerator.generateAllPaths(machine);
  await testGenerator.writeTests(allPaths);
}
