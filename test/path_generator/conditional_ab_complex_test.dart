import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/zhang_path_generator.dart';
import 'package:simple_state_machine/state_machine.dart';
import 'package:test/test.dart';

import 'package:dart_bloc_mbt_generator/examples/cubit_examples/conditional_ab_complex/statemachine/conditional_ab_complex_statemachine.dart';

void main() {
  group('pathGeneratorSingleFileSimpleAb', () {
    //Setup object once for all tests
    // Generate model files from cubit
    StateMachine sm = constructConditionalAbComplexStatemachine();
    ZhangPathGenerator pathGenerator = ZhangPathGenerator();
    List<Path> paths = pathGenerator.generatePaths(sm);
    Path path = paths[0];

    test('Expect one path in paths', () {
      expect(paths.length, 1);
    });

    test('Expect pathInputs not to be empty', () {
      expect(path.pathInputs.where((element) => element.isEmpty).length, 1);
      expect(path.pathInputs.where((element) => element.isNotEmpty).length, 10);
    });

    test('Expect transitons to only contain 11 unique transitions', () {
      expect(path.transitions.toSet().length, 11);
    });
  });
}
