// @dart=2.9
import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';
import 'package:state_machine/state_machine.dart';
import 'package:test/test.dart';

void main() {
  group('analyzeSingleFileSimpleAb', () {
    //Setup object once for all tests
    // Generate model files from cubit
    String relativePath =
        'examples/cubit_examples/simple_ab/cubit/simple_ab_cubit.dart';
    StateMachine result = Analyzer.analyzeSingleFile(relativePath);

    test('fileName', () {
      expect(result.name, 'SimpleAb');
    });

    test('states', () {
      expect(result.states.map((s) => s.name).toSet(),
          equals({'SimpleA', 'SimpleB'}));
    });

    test('startingState', () {
      expect(result.current.name, equals('SimpleA'));
    });

    test('transitionLength', () {
      for (State s in result.states) {
        expect(s.transitions.length, equals(2));
      }
    });

    test('transitions_goToA', () {
      //Forgive me for the following code
      for (State s in result.states) {
        StateTransition t = s.transitions.firstWhere((t) => t.name == "goToA");

        expect(t.from, hasLength(2));
        expect(t.from.map((e) => e.name).toList(),
            containsAll(['SimpleA', 'SimpleB']));

        expect(t.to.name, equals('SimpleA'));
      }
    });

    test('transitions_goToB', () {
      //Forgive me for the following code
      for (State s in result.states) {
        StateTransition t = s.transitions.firstWhere((t) => t.name == "goToB");

        expect(t.from, hasLength(2));
        expect(t.from.map((e) => e.name).toList(),
            containsAll(['SimpleA', 'SimpleB']));

        expect(t.to.name, equals('SimpleB'));
      }
    });
  });
}
