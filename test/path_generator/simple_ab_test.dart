import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/zhang_path_generator.dart';
import 'package:simple_state_machine/state_machine.dart';
import 'package:test/test.dart';

import 'package:dart_bloc_mbt_generator/examples/cubit_examples/simple_ab/statemachine/simple_ab_statemachine.dart';

void main() {
  group('pathGeneratorSingleFileSimpleAb', () {
    //Setup object once for all tests
    // Generate model files from cubit
    StateMachine sm = constructSimpleAbStatemachine();
    ZhangPathGenerator pathGenerator = ZhangPathGenerator();
    List<Path> paths = pathGenerator.generatePaths(sm);
    Path path = paths[0];

    test('Expect one path in paths', () {
      expect(paths.length, 1);
    });

    test('Expect path to have 1 transition', () {
      expect(path.transitions.length, 1);
    });
  });
}
