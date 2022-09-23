import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dart_bloc_mbt_generator/examples/cubit_examples/conditional_ab_complex/cubit/conditional_ab_complex_cubit.dart';

void main() {
  group('ConditionalAbComplexCubit', () {
    late ConditionalAbComplexCubit conditionalAbComplexCubit;

    setUp(() {
      conditionalAbComplexCubit = ConditionalAbComplexCubit();
    });

    blocTest<ConditionalAbComplexCubit, ConditionalAbComplexState>(
      'emits [Conditional0, Conditional0, Conditional0, Conditional0, Conditional0]',
      build: () => conditionalAbComplexCubit,
      act: (cubit) => [
        cubit.goToInt(0),
        cubit.goToInt(0),
        cubit.goToInt(0),
        cubit.goToInt(0),
        cubit.goToInt(0)
      ],
      expect: () => [
        Conditional0,
        Conditional0,
        Conditional0,
        Conditional0,
        Conditional0
      ],
    );
  });
}
