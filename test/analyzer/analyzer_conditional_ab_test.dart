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
      expect(result.states, equals({'ConditionalA', 'ConditionalB'}));
    });

    test('startingState', () {
      expect(result.initial, equals('ConditionalA'));
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
      expect(
          result.states.any((State state) => state.transitions.any((tr) =>
              tr.name == "goToA" &&
              tr.from.length == 2 &&
              tr.to.toString() == "ConditionalA" &&
              tr.conditions == BinaryExpressionTree() &&
              tr.inputTypes == {})),
          true);
    });

    // test('transition_goToB', () {
    //   expect(
    //       result.transitions,
    //       contains(Transition(
    //           "goToB",
    //           {'ConditionalA', 'ConditionalB'},
    //           'ConditionalB',
    //           BinaryExpressionTree(root: Node('allowed')),
    //           LinkedHashMap.from({'allowed': 'bool'}))));
    // });
  });
}
