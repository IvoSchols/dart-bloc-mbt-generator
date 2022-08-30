import 'dart:js_util';

import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';
import 'package:state_machine/state_machine.dart';
import 'package:test/test.dart';

void main() {
  group('analyzeSingleFileConditionalAb', () {
    // Generate model files from cubit
    String relativePath =
        'examples/cubit_examples/conditional_ab/cubit/conditional_ab_cubit.dart';
    StateMachine result = Analyzer.analyzeSingleFile(relativePath);

    test('name', () {
      expect(result.name, 'ConditionalAb');
    });

    test('states', () {
      expect(result.states.map((s) => s.name),
          equals({'ConditionalA', 'ConditionalB'}));
    });

    test('startingState', () {
      expect(result.initial.name, equals('ConditionalA'));
    });

    test('transitionLength', () {
      expect(
          result.states.fold(
              0,
              (int previousValue, element) =>
                  previousValue + element.transitions.length),
          equals(4));
    });

    test('transition_goToA', () {
      Transition goToA = result.states
          .firstWhere((s) => s.name == 'ConditionalA')
          .transitions
          .firstWhere((t) => t.name == 'goToA');
      Transition goToA2 = result.states
          .firstWhere((s) => s.name == 'ConditionalB')
          .transitions
          .firstWhere((t) => t.name == 'goToA');

      expect(goToA, equals(goToA2));

      expect(goToA.from, hasLength(2));
      expect(goToA.from.map((e) => e.name).toList(),
          containsAll(['ConditionalA', 'ConditionalB']));
      expect(goToA.to.name, equals('ConditionalA'));
      expect(goToA.conditions, isNotNull);
      expect(goToA.conditions!.root, equals(BinaryExpressionTree().root));

      expect(goToA.inputTypes, equals({}));
    });

    test('transition_goToB', () {
      Transition goToA = result.states
          .firstWhere((s) => s.name == 'ConditionalA')
          .transitions
          .firstWhere((t) => t.name == 'goToB');
      Transition goToA2 = result.states
          .firstWhere((s) => s.name == 'ConditionalB')
          .transitions
          .firstWhere((t) => t.name == 'goToB');

      expect(goToA, equals(goToA2));

      expect(goToA.from, hasLength(2));
      expect(goToA.from.map((e) => e.name).toList(),
          containsAll(['ConditionalA', 'ConditionalB']));
      expect(goToA.to.name, equals('ConditionalB'));
      expect(goToA.conditions, isNotNull);
      expect(true, instanceof(goToA.conditions!.root, Node));
      expect(goToA.conditions!.root!.value, equals('allowed'));

      expect(goToA.inputTypes, equals({}));
    });
  });
}
