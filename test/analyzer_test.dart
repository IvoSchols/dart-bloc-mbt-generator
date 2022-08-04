// @dart=2.9

import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitor/cubit_visitor.dart';
import 'package:test/test.dart';

void main() {
  group('Analyzer', () {
    test('analyzeSingleFileSimpleAb', () {
      // Generate model files from cubit
      String relativePath =
          'examples/cubit_examples/simple_ab/cubit/simple_ab_cubit.dart';
      VisitedCubit result = Analyzer.analyzeSingleFile(relativePath);

      expect(result.name, 'SimpleAbCubit');

      expect(result.states, contains('SimpleA'));
      expect(result.states, contains('SimpleB'));
      expect(result.states.length, equals(2));

      expect(result.startingState, equals('SimpleA'));

      expect(result.transitions.length, equals(2));
      expect(
          result.transitions[0],
          equals(CubitStateTransition(
              "goToA", ['SimpleA', 'SimpleB'], 'SimpleA')));
      expect(
          result.transitions[1],
          equals(CubitStateTransition(
              "goToB", ['SimpleA', 'SimpleB'], 'SimpleB')));
    });
  });
}
