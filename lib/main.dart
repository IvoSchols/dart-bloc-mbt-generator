// @dart=2.9
import 'package:dart_bloc_mbt_generator/code_analyzer/visitor/cubit_visitor.dart';
import 'package:dart_bloc_mbt_generator/file_generator/model_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/simple_path_generator.dart';
import 'package:dart_bloc_mbt_generator/file_generator/test_generator.dart';
import 'package:state_machine/state_machine.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';

import 'package:dart_bloc_mbt_generator/examples/cubit_examples/simple_ab/statemachine/simple_ab_statemachine.dart';
// import 'package:dart_bloc_mbt_generator/generated_examples/simple_ab.dart';

Future<void> main() async {
  // Generate model files from cubit
  String relativePath =
      'examples/cubit_examples/simple_ab/cubit/simple_ab_cubit.dart';
  //TODO: remove parentehses when reading in file
  VisitedCubit result = Analyzer.analyzeSingleFile(relativePath);
  CubitModelGenerator(relativePath, result).writeModel();

  //Generate tests from statemachine
  final StateMachine machine = constructSimpleAbStatemachine();
  TestGenerator testGenerator = TestGenerator(relativePath, machine);
  final PathGenerator pathGenerator = SimplePathGenerator();
  final List<Path> paths = pathGenerator.generatePaths(machine);
  await testGenerator.writeTests(paths);
}
