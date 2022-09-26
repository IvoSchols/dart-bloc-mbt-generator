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
      'emits [Conditional0, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9]',
      build: () => conditionalAbComplexCubit,
      act: (cubit) => [
        cubit.goToInt(0),
        cubit.goToInt(3),
        cubit.goToInt(-12),
        cubit.goToInt(-1),
        cubit.goToInt(-11)
      ],
      expect: () => [
        Conditional0(),
        Conditional3(),
        ConditionalMinus12(),
        ConditionalMinus7(),
        ConditionalMinus9()
      ],
    );
  });
}
