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
      expect(goToA.conditions, isNull);
    });

    test('transition_goToB', () {
      Transition goToB = result.states
          .firstWhere((s) => s.name == 'ConditionalA')
          .transitions
          .firstWhere((t) => t.name == 'goToB');
      Transition goToB2 = result.states
          .firstWhere((s) => s.name == 'ConditionalB')
          .transitions
          .firstWhere((t) => t.name == 'goToB');

      expect(goToB, equals(goToB2));

      expect(goToB.from, hasLength(2));
      expect(goToB.from.map((e) => e.name).toList(),
          containsAll(['ConditionalA', 'ConditionalB']));
      expect(goToB.to.name, equals('ConditionalB'));
      expect(goToB.conditions, isNotNull);
      Node? root = goToB.conditions!['conditionTree'].root;
      expect(root, isNotNull);
      expect(root!.value, equals('allowed'));

      expect(goToB.conditions!['inputTypes'], equals({'allowed': 'bool'}));
    });
  });
}
