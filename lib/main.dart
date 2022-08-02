// @dart=2.9
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/simple_path_generator.dart';
import 'package:dart_bloc_mbt_generator/examples/cubit_examples/simpleAB/statemachine/simpleAB_statemachine.dart';
import 'package:state_machine/state_machine.dart';

// void main(List<String> args) {
//   final StateMachine machine = constructSimpleABStatemachine();

//   PathGenerator pathGenerator = SimplePathGenerator();
//   List<Paths> allPaths = pathGenerator.generateAllPaths(machine);
//   print(allPaths.toString());
//   print("hello");
//   // machine.newState

//   // print(machine.states);
// }
import 'dart:io';

import 'package:mason/mason.dart';

Future<void> main() async {
  final brick = Brick.path("bricks/cubit_test");
  final generator = await MasonGenerator.fromBrick(brick);
  final target = DirectoryGeneratorTarget(Directory("test"));
  List<GeneratedFile> generatedFile = await generator.generate(
    target,
    vars: <String, dynamic>{
      'name': 'simple ab',
      'imports': [
        {
          'import':
              'package:dart_bloc_mbt_generator/examples/cubit_examples/simpleAB/cubit/simple_ab_cubit.dart'
        }
      ],
      'cubit': 'SimpleAbCubit',
      'tests': [
        {
          'stateClass': 'SimpleAbState',
          'functions': [
            {
              'function': 'cubit.goToB()',
            }
          ],
          'states': [
            {
              'state': 'SimpleB()',
            }
          ],
        },
        {
          'stateClass': 'SimpleAbState',
          'functions': [
            {
              'function': 'cubit.goToB()',
            },
            {
              'function': 'cubit.goToA()',
            }
          ],
          'states': [
            {
              'state': 'SimpleB()',
            },
            {
              'state': 'SimpleA()',
            }
          ],
        },
      ],
    },
  );
  print(generatedFile.toString());

  // Format the newly written test file
  Process.run('dart', ['format', "test/simple_ab.dart"]).then((result) {
    stdout.write(result.stdout);
    stderr.write(result.stderr);
  });
}
