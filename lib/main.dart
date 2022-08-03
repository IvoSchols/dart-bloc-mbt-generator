// @dart=2.9
import 'dart:io';

import 'package:dart_bloc_mbt_generator/file_generator/file_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/simple_path_generator.dart';
import 'package:dart_bloc_mbt_generator/examples/cubit_examples/simple_ab/statemachine/simple_ab_statemachine.dart';
import 'package:dart_bloc_mbt_generator/file_generator/test_generator.dart';
import 'package:state_machine/state_machine.dart';
import 'examples/cubit_examples/simple_ab/cubit/simple_ab_cubit.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';
import 'package:mason/mason.dart';

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
  // Generate model files from cubit
  String relativePath =
      'examples/cubit_examples/simple_ab/cubit/simple_ab_cubit.dart';
  dynamic result = Analyzer.analyzeSingleFile(relativePath);

  final brick = Brick.path("bricks/statemachine_model_cubit");
  final generator = await MasonGenerator.fromBrick(brick);
  final target = DirectoryGeneratorTarget(
      Directory("examples/cubit_examples/simple_ab/statemachine"));
  List<GeneratedFile> generatedFile = await generator.generate(
    target,
    vars: <String, dynamic>{},
  );
  print(generatedFile.toString());

  // Format the newly written test file
  //TODO: add generated file path
  FileGeneratorHelperFunctions.formatFiles([]);

  //Generate tests from statemachine
  final StateMachine machine = constructSimpleABStatemachine();
  TestGenerator testGenerator = TestGenerator(relativePath, machine);
  final PathGenerator pathGenerator = SimplePathGenerator();
  final List<Paths> allPaths = pathGenerator.generateAllPaths(machine);
  await testGenerator.writeTests(allPaths);
}
