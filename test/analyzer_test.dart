// @dart=2.9

import 'dart:math';

import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitor/cubit_visitor.dart';
import 'package:test/test.dart';

void main() {
  group('Analyzer', () {
    group('analyzeSingleFileSimpleAb', () {
      //Setup object once for all tests
      // Generate model files from cubit
      String relativePath =
          'examples/cubit_examples/simple_ab/cubit/simple_ab_cubit.dart';
      VisitedCubit result = Analyzer.analyzeSingleFile(relativePath);

      test('fileName', () {
        expect(result.name, 'SimpleAbCubit');
      });

      test('states', () {
        expect(result.states, equals({'SimpleA', 'SimpleB'}));
        //TODO: does this test length?
      });

      test('startingState', () {
        expect(result.startingState, equals('SimpleA'));
      });

      test('transitionLength', () {
        expect(result.transitions.length, equals(2));
      });

      test('transitions_goToA', () {
        expect(
            result.transitions,
            contains(CubitStateTransition(
                "goToA", ['SimpleA', 'SimpleB'], 'SimpleA')));
      });

      test('transitions_goToB', () {
        expect(
            result.transitions,
            contains(CubitStateTransition(
                "goToB", ['SimpleA', 'SimpleB'], 'SimpleB')));
      });
    });

    group('analyzeSingleFileConditionalAb', () {
      // Generate model files from cubit
      String relativePath =
          'examples/cubit_examples/conditional_ab/cubit/conditional_ab_cubit.dart';
      VisitedCubit result = Analyzer.analyzeSingleFile(relativePath);

      test('name', () {
        expect(result.name, 'ConditionalAbCubit');
      });

      test('states', () {
        expect(result.states, equals({'ConditionalA', 'ConditionalB'}));
      });

      test('startingState', () {
        expect(result.startingState, equals('ConditionalA'));
      });

      test('transitionLength', () {
        expect(result.transitions.length, equals(2));
      });

      test('transition_goToA', () {
        expect(
            result,
            contains(CubitStateTransition(
                "goToA", ['ConditionalA', 'ConditionalB'], 'ConditionalA')));
      });

      test('transition_goToB', () {
        expect(
            result,
            contains(CubitStateTransition(
                "goToB", ['ConditionalA', 'ConditionalB'], 'ConditionalB')));
      });

      //TODO: add conditions
    });
  });
}
