import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';
import 'package:state_machine/state_machine.dart';
import 'package:test/test.dart';

void main() {
  group('analyzeSingleFileConditionalAbComplex', () {
    // Generate model files from cubit
    String relativePath =
        'examples/cubit_examples/conditional_ab_complex/cubit/conditional_ab_complex_cubit.dart';
    StateMachine result = Analyzer.analyzeSingleFile(relativePath);

    test('name', () {
      expect(result.name, 'ConditionalAbComplex');
    });

    test('states', () {
      expect(
          result.states.map((s) => s.name),
          equals({
            'ConditionalA',
            'ConditionalBool',
            'Conditional0',
            'Conditional3',
            'ConditionalMinus12',
            'ConditionalMinus7',
            'ConditionalMinus9',
            'ConditionalMinus8',
            'ConditionalStringFoo',
            'ConditionalStringBar'
          }));
    });

    test('startingState', () {
      expect(result.initial.name, equals('ConditionalA'));
    });

    test('transitionLength', () {
      expect(result.allTransitions.length, equals(11));
    });

    test('transition_goToA', () {
      Transition goToA = result.states
          .firstWhere((s) => s.name == 'ConditionalA')
          .transitions
          .firstWhere((Transition t) => t.name == 'goToA');
      expect(goToA.conditions, isNull);
      expect(goToA.to.name, equals('ConditionalA'));
    });

    test('transition_goToInt0', () {
      Transition goToInt = result.states
          .firstWhere((s) => s.name == 'ConditionalA')
          .transitions
          .firstWhere((Transition t) =>
              t.name == 'goToInt' && t.to.name == 'Conditional0');

      expect(goToInt.conditions, isNotNull);

      expect(goToInt.conditions!['inputTypes'], isNotNull);
      expect(goToInt.conditions!['inputTypes']!.length, equals(1));
      expect(goToInt.conditions!['inputTypes']!['value'], equals('int'));

      expect(goToInt.conditions!['conditionTree'], isNotNull);
      BinaryExpressionTree conditionTree =
          goToInt.conditions!['conditionTree']!;
      expect(conditionTree.root, isNotNull);
      expect(conditionTree.root!.value, equals('=='));
      expect(conditionTree.root!.left!.value, equals('value'));
      expect(conditionTree.root!.right!.value, equals('0'));
    });

    test('transition_goToInt3', () {
      Transition goToInt = result.states
          .firstWhere((s) => s.name == 'ConditionalA')
          .transitions
          .firstWhere((Transition t) =>
              t.name == 'goToInt' && t.to.name == 'Conditional3');

      expect(goToInt.conditions, isNotNull);

      expect(goToInt.conditions!['inputTypes'], isNotNull);
      expect(goToInt.conditions!['inputTypes']!.length, equals(1));
      expect(goToInt.conditions!['inputTypes']!['value'], equals('int'));

      expect(goToInt.conditions!['conditionTree'], isNotNull);
      BinaryExpressionTree conditionTree =
          goToInt.conditions!['conditionTree']!;
      expect(conditionTree.root, isNotNull);
      expect(conditionTree.root!.value, equals('&&'));

      expect(conditionTree.root!.left!.value, equals('!='));
      expect(conditionTree.root!.left!.left!.value, equals('value'));
      expect(conditionTree.root!.left!.right!.value, equals('0'));

      expect(conditionTree.root!.right!.value, equals('>='));
      expect(conditionTree.root!.right!.left!.value, equals('value'));
      expect(conditionTree.root!.right!.right!.value, equals('3'));
    });

    test('transition_goToIntMinus12', () {
      Transition goToInt = result.states
          .firstWhere((s) => s.name == 'ConditionalA')
          .transitions
          .firstWhere((Transition t) =>
              t.name == 'goToInt' && t.to.name == 'ConditionalMinus12');

      expect(goToInt.conditions, isNotNull);

      expect(goToInt.conditions!['inputTypes'], isNotNull);
      expect(goToInt.conditions!['inputTypes']!.length, equals(1));
      expect(goToInt.conditions!['inputTypes']!['value'], equals('int'));

      expect(goToInt.conditions!['conditionTree'], isNotNull);
      BinaryExpressionTree conditionTree =
          goToInt.conditions!['conditionTree']!;
      expect(conditionTree.root, isNotNull);
      expect(conditionTree.root!.value, equals('&&'));

      expect(conditionTree.root!.left!.value, equals('&&'));

      expect(conditionTree.root!.left!.left!.value, equals('!='));

      expect(conditionTree.root!.left!.right!.value, equals('<'));

      expect(conditionTree.root!.right!.value, equals('<='));
    });

    test('transition_goToIntMinus7', () {
      Transition goToInt = result.states
          .firstWhere((s) => s.name == 'ConditionalA')
          .transitions
          .firstWhere((Transition t) =>
              t.name == 'goToInt' && t.to.name == 'ConditionalMinus7');

      expect(goToInt.conditions, isNotNull);

      expect(goToInt.conditions!['inputTypes'], isNotNull);
      expect(goToInt.conditions!['inputTypes']!.length, equals(1));
      expect(goToInt.conditions!['inputTypes']!['value'], equals('int'));

      expect(goToInt.conditions!['conditionTree'], isNotNull);
      BinaryExpressionTree conditionTree =
          goToInt.conditions!['conditionTree']!;
      expect(conditionTree.root, isNotNull);
      expect(conditionTree.root!.value, equals('&&'));

      expect(conditionTree.root!.left!.value, equals('&&'));
      expect(conditionTree.root!.left!.right!.value, equals('>'));

      expect(conditionTree.root!.left!.left!.value, equals('&&'));
      expect(conditionTree.root!.left!.left!.left!.value, equals('!='));

      expect(conditionTree.root!.left!.left!.right!.value, equals('<'));

      expect(conditionTree.root!.right!.value, equals('>'));
    });

    test('transition_goToIntMinus9', () {
      Transition goToInt = result.states
          .firstWhere((s) => s.name == 'ConditionalA')
          .transitions
          .firstWhere((Transition t) =>
              t.name == 'goToInt' && t.to.name == 'ConditionalMinus9');

      expect(goToInt.conditions, isNotNull);

      expect(goToInt.conditions!['inputTypes'], isNotNull);
      expect(goToInt.conditions!['inputTypes']!.length, equals(1));
      expect(goToInt.conditions!['inputTypes']!['value'], equals('int'));

      expect(goToInt.conditions!['conditionTree'], isNotNull);
      BinaryExpressionTree conditionTree =
          goToInt.conditions!['conditionTree']!;
      expect(conditionTree.root, isNotNull);
      expect(conditionTree.root!.value, equals('&&'));

      expect(conditionTree.root!.left!.value, equals('&&'));
      expect(conditionTree.root!.left!.right!.value, equals('<='));

      expect(conditionTree.root!.left!.left!.value, equals('&&'));
      expect(conditionTree.root!.left!.left!.right!.value, equals('>'));

      expect(conditionTree.root!.left!.left!.left!.value, equals('&&'));

      expect(conditionTree.root!.left!.left!.left!.left!.value, equals('!='));
      expect(conditionTree.root!.left!.left!.left!.right!.value, equals('<'));

      expect(conditionTree.root!.right!.value, equals('<'));
    });

    test('transition_goToIntMinus8', () {
      Transition goToInt = result.states
          .firstWhere((s) => s.name == 'ConditionalA')
          .transitions
          .firstWhere((Transition t) =>
              t.name == 'goToInt' && t.to.name == 'ConditionalMinus8');

      expect(goToInt.conditions, isNotNull);

      expect(goToInt.conditions!['inputTypes'], isNotNull);
      expect(goToInt.conditions!['inputTypes']!.length, equals(1));
      expect(goToInt.conditions!['inputTypes']!['value'], equals('int'));

      expect(goToInt.conditions!['conditionTree'], isNotNull);
      BinaryExpressionTree conditionTree =
          goToInt.conditions!['conditionTree']!;
      expect(conditionTree.root, isNotNull);
      expect(conditionTree.root!.value, equals('&&'));

      expect(conditionTree.root!.left!.value, equals('&&'));
      expect(conditionTree.root!.left!.right!.value, equals('<='));

      expect(conditionTree.root!.left!.left!.value, equals('&&'));
      expect(conditionTree.root!.left!.left!.right!.value, equals('>'));

      expect(conditionTree.root!.left!.left!.left!.value, equals('&&'));

      expect(conditionTree.root!.left!.left!.left!.left!.value, equals('!='));
      expect(conditionTree.root!.left!.left!.left!.right!.value, equals('<'));

      expect(conditionTree.root!.right!.value, equals('>='));
    });

    test('goToStringFoo', () {
      Transition goToStringFoo = result.states
          .firstWhere((s) => s.name == 'ConditionalA')
          .transitions
          .firstWhere((Transition t) =>
              t.name == 'goToString' && t.to.name == 'ConditionalStringFoo');

      expect(goToStringFoo.conditions, isNotNull);
      BinaryExpressionTree conditionTree =
          goToStringFoo.conditions!['conditionTree']!;

      expect(conditionTree.root, isNotNull);
      expect(conditionTree.root!.value, equals('=='));
      expect(conditionTree.root!.left!.value, equals('value'));
      expect(conditionTree.root!.right!.value, equals('foo'));

      Map<String, String> inputTypes = goToStringFoo.conditions!['inputTypes'];

      expect(inputTypes, isNotNull);
      expect(inputTypes["value"], isNotNull);
      expect(inputTypes["value"], equals('String'));
    });

    test('goToStringBar', () {
      Transition goToStringFoo = result.states
          .firstWhere((s) => s.name == 'ConditionalA')
          .transitions
          .firstWhere((Transition t) =>
              t.name == 'goToString' && t.to.name == 'ConditionalStringBar');

      expect(goToStringFoo.conditions, isNotNull);
      BinaryExpressionTree conditionTree =
          goToStringFoo.conditions!['conditionTree']!;

      expect(conditionTree.root, isNotNull);
      expect(conditionTree.root!.value, equals('&&'));
      expect(conditionTree.root!.left!.value, equals('!='));
      expect(conditionTree.root!.right!.value, equals('=='));

      expect(conditionTree.root!.left!.left!.value, equals('value'));
      expect(conditionTree.root!.left!.right!.value, equals('foo'));

      expect(conditionTree.root!.right!.left!.value, equals('value'));
      expect(conditionTree.root!.right!.right!.value, equals('bar'));

      Map<String, String> inputTypes = goToStringFoo.conditions!['inputTypes'];

      expect(inputTypes, isNotNull);
      expect(inputTypes["value"], isNotNull);
      expect(inputTypes["value"], equals('String'));
    });
  });
}
