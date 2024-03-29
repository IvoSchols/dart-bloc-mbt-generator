import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';
import 'package:simple_state_machine/state_machine.dart';
import 'package:test/test.dart';

void main() {
  group('analyzeSingleFileConditionalAbNegated', () {
    // Generate model files from cubit
    String relativePath =
        'examples/cubit_examples/conditional_ab_negated/cubit/conditional_ab_negated_cubit.dart';
    StateMachine result = Analyzer.analyzeSingleFile(relativePath);

    test('name', () {
      expect(result.name, 'ConditionalAbNegated');
    });

    test('states', () {
      expect(result.states.map((s) => s.name),
          equals({'conditionalA', 'conditionalB'}));
    });

    test('startingState', () {
      expect(result.initial.name, equals('conditionalA'));
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
          .firstWhere((s) => s.name == 'conditionalA')
          .transitions
          .firstWhere((t) => t.name == 'goToA');
      Transition goToA2 = result.states
          .firstWhere((s) => s.name == 'conditionalB')
          .transitions
          .firstWhere((t) => t.name == 'goToA');

      expect(goToA, equals(goToA2));

      expect(goToA.from, hasLength(2));
      expect(goToA.from.map((e) => e.name).toList(),
          containsAll(['conditionalA', 'conditionalB']));
      expect(goToA.to.name, equals('conditionalA'));
      expect(goToA.conditions, isNull);
    });

    test('transition_goToB', () {
      Transition goToB = result.states
          .firstWhere((s) => s.name == 'conditionalA')
          .transitions
          .firstWhere((t) => t.name == 'goToB');
      Transition goToB2 = result.states
          .firstWhere((s) => s.name == 'conditionalB')
          .transitions
          .firstWhere((t) => t.name == 'goToB');

      expect(goToB, equals(goToB2));

      expect(goToB.from, hasLength(2));
      expect(goToB.from.map((e) => e.name).toList(),
          containsAll(['conditionalA', 'conditionalB']));
      expect(goToB.to.name, equals('conditionalB'));
      expect(goToB.conditions, isNotNull);
      Node? root = goToB.conditions!['conditionTree'].root;
      expect(root, isNotNull);
      expect(root!.value, equals('!'));
      expect(root.left!.value, equals('allowed'));

      expect(goToB.conditions!['inputTypes'], equals({'allowed': 'bool'}));
    });
  });
}
