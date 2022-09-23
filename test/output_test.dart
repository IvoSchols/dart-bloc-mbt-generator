import 'dart:io';

import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';
import 'package:dart_bloc_mbt_generator/file_generator/test_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/zhang_path_generator.dart';
import 'package:state_machine/state_machine.dart';
import 'package:test/test.dart';

void main() {
  group('OutputSimpleAbTest', () {
    //TODO: refactor main so that it can be tested
    //Test if simple ab test file was created and content equals example test file
    test('simpleAbOutput', () async {
      // Generate finite state machine model from cubit and write to file
      String relativePath =
          'examples/cubit_examples/simple_ab/cubit/simple_ab_cubit.dart';

      StateMachine stateMachine = Analyzer.analyzeSingleFile(relativePath);
      //Generate tests from finite state machine model DFS walks and write tests to file

      final PathGenerator pathGenerator = ZhangPathGenerator();
      final List<Path> paths = pathGenerator.generatePaths(stateMachine);

      TestGenerator testGenerator = CubitGenerator(relativePath, stateMachine);
      await testGenerator.writeTests(paths);

      //Expect content of lib/gen/tests/simple_ab.dart to equal content of
      //lib/examples/cubit_examples/simple_ab/test/SimpleAb.dart
      File generated = File('lib/gen/tests/SimpleAb.dart');
      File example =
          File('lib/examples/cubit_examples/simple_ab/test/SimpleAb.dart');

      expect(example.readAsStringSync(), generated.readAsStringSync());
    });
  });
}
