// @dart=2.9
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
import 'package:dart_bloc_mbt_generator/file_generator/model_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/simple_path_generator.dart';
import 'package:dart_bloc_mbt_generator/file_generator/test_generator.dart';
import 'package:state_machine/state_machine.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';

import 'package:dart_bloc_mbt_generator/examples/cubit_examples/simple_ab/statemachine/simple_ab_statemachine.dart';
// import 'package:dart_bloc_mbt_generator/generated_examples/simple_ab.dart';

Future<void> main() async {
  // Generate finite state machine model from cubit and write to file
  String relativePath =
      'examples/cubit_examples/conditional_ab/cubit/conditional_ab_cubit.dart';

  VisitedCubit vCubit = Analyzer.analyzeSingleFile(relativePath);

  CubitModelGenerator(relativePath).writeModel(vCubit);

  //Generate tests from finite state machine model DFS walks and write tests to file
  //
  final StateMachine machine = constructSimpleAbStatemachine();

  final PathGenerator pathGenerator = SimplePathGenerator();
  final List<Path> paths = pathGenerator.generatePaths(machine);

  TestGenerator testGenerator = TestGenerator(relativePath, machine);
  await testGenerator.writeTests(paths);
}
