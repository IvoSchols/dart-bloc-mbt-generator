import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';
import 'package:state_machine/state_machine.dart';
import 'package:test/test.dart';

void main() {
  group('analyzeSingleFileConditionalAbComplex', () {
    // Generate model files from cubit
    String relativePath =
        'examples/cubit_examples/traffic_light/cubit/traffic_light_cubit.dart';
    StateMachine result = Analyzer.analyzeSingleFile(relativePath);

    test('name', () {
      expect(result.name, 'TrafficLight');
    });

    test('states', () {
      expect(
          result.states.map((s) => s.name),
          equals({
            'Red',
            'Green',
            'Yellow',
            'Exception',
          }));
    });

    test('startingState', () {
      expect(result.initial.name, equals('Red'));
    });

    test('transitionLength', () {
      expect(result.allTransitions.length, equals(4));
    });

    test('transition_changeTrafficLightToRed', () {
      Transition changeTrafficLightTo = result.states
          .firstWhere((s) => s.name == 'Green')
          .transitions
          .firstWhere((Transition t) =>
              t.name == 'changeTrafficLightTo' && t.to.name == 'Red');
      expect(changeTrafficLightTo.conditions, isNotNull);

      Map<String, String> inputTypes =
          changeTrafficLightTo.conditions!['inputTypes'];

      expect(inputTypes.length, equals(1));
      expect(inputTypes['color'], equals('String'));

      BinaryExpressionTree conditionTree =
          changeTrafficLightTo.conditions!['conditionTree']!;

      expect(conditionTree.root!.value, equals('=='));
      expect(conditionTree.root!.left!.value, equals('color'));
      expect(conditionTree.root!.right!.value, equals('red'));

      expect(conditionTree.root!.left!.left, isNull);
      expect(conditionTree.root!.left!.right, isNull);
      expect(conditionTree.root!.right!.left, isNull);
      expect(conditionTree.root!.right!.right, isNull);
    });

    test('transition_changeTrafficLightToGreen', () {
      Transition changeTrafficLightTo = result.states
          .firstWhere((s) => s.name == 'Red')
          .transitions
          .firstWhere((Transition t) =>
              t.name == 'changeTrafficLightTo' && t.to.name == 'Green');
      expect(changeTrafficLightTo.conditions, isNotNull);

      Map<String, String> inputTypes =
          changeTrafficLightTo.conditions!['inputTypes'];

      expect(inputTypes.length, equals(1));
      expect(inputTypes['color'], equals('String'));

      BinaryExpressionTree conditionTree =
          changeTrafficLightTo.conditions!['conditionTree']!;

      expect(conditionTree.root!.value, equals('=='));
      expect(conditionTree.root!.left!.value, equals('color'));
      expect(conditionTree.root!.right!.value, equals('green'));

      expect(conditionTree.root!.left!.left, isNull);
      expect(conditionTree.root!.left!.right, isNull);
      expect(conditionTree.root!.right!.left, isNull);
      expect(conditionTree.root!.right!.right, isNull);
    });

    test('transition_changeTrafficLightToYellow', () {
      Transition changeTrafficLightTo = result.states
          .firstWhere((s) => s.name == 'Red')
          .transitions
          .firstWhere((Transition t) =>
              t.name == 'changeTrafficLightTo' && t.to.name == 'Yellow');
      expect(changeTrafficLightTo.conditions, isNotNull);

      Map<String, String> inputTypes =
          changeTrafficLightTo.conditions!['inputTypes'];

      expect(inputTypes.length, equals(1));
      expect(inputTypes['color'], equals('String'));

      BinaryExpressionTree conditionTree =
          changeTrafficLightTo.conditions!['conditionTree']!;

      expect(conditionTree.root!.value, equals('=='));
      expect(conditionTree.root!.left!.value, equals('color'));
      expect(conditionTree.root!.right!.value, equals('yellow'));

      expect(conditionTree.root!.left!.left, isNull);
      expect(conditionTree.root!.left!.right, isNull);
      expect(conditionTree.root!.right!.left, isNull);
      expect(conditionTree.root!.right!.right, isNull);
    });

    test('transition_changeTrafficLightToException', () {
      Transition changeTrafficLightTo = result.states
          .firstWhere((s) => s.name == 'Red')
          .transitions
          .firstWhere((Transition t) =>
              t.name == 'changeTrafficLightTo' && t.to.name == 'Exception');
      expect(changeTrafficLightTo.conditions, isNotNull);

      Map<String, String> inputTypes =
          changeTrafficLightTo.conditions!['inputTypes'];

      expect(inputTypes.length, equals(1));
      expect(inputTypes['color'], equals('String'));

      BinaryExpressionTree conditionTree =
          changeTrafficLightTo.conditions!['conditionTree']!;

      expect(conditionTree.root!.value, equals('&&'));
      expect(conditionTree.root!.left!.value, equals('&&'));
      expect(conditionTree.root!.right!.value, equals('!='));

      expect(conditionTree.root!.right!.left!.value, equals('color'));
      expect(conditionTree.root!.right!.left!.getChildren(), equals([]));
      expect(conditionTree.root!.right!.right!.value, equals('yellow'));
      expect(conditionTree.root!.right!.right!.getChildren(), equals([]));

      expect(conditionTree.root!.left!.right!.value, equals('!='));
      expect(conditionTree.root!.left!.right!.left!.value, equals('color'));
      expect(conditionTree.root!.left!.right!.left!.getChildren(), equals([]));
      expect(conditionTree.root!.left!.right!.right!.value, equals('green'));
      expect(conditionTree.root!.left!.right!.right!.getChildren(), equals([]));

      expect(conditionTree.root!.left!.left!.value, equals('!='));
      expect(conditionTree.root!.left!.left!.left!.value, equals('color'));
      expect(conditionTree.root!.left!.left!.left!.getChildren(), equals([]));
      expect(conditionTree.root!.left!.left!.right!.value, equals('red'));
      expect(conditionTree.root!.left!.left!.right!.getChildren(), equals([]));
    });
  });
}
