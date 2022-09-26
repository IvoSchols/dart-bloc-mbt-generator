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
      'emits [ConditionalBool, ConditionalA, Conditional0, ConditionalA, Conditional3, ConditionalMinus12, ConditionalMinus7, ConditionalMinus9, ConditionalMinus8, ConditionalStringFoo, ConditionalStringBar]',
      build: () => conditionalAbComplexCubit,
      act: (cubit) => [
        cubit.goToBool(true),
        cubit.goToA(),
        cubit.goToInt(0),
        cubit.goToBool(false),
        cubit.goToInt(3),
        cubit.goToInt(-12),
        cubit.goToInt(-1),
        cubit.goToInt(-11),
        cubit.goToInt(-8),
        cubit.goToString("foo"),
        cubit.goToString("bar")
      ],
      expect: () => [
        ConditionalBool(),
        ConditionalA(),
        Conditional0(),
        ConditionalA(),
        Conditional3(),
        ConditionalMinus12(),
        ConditionalMinus7(),
        ConditionalMinus9(),
        ConditionalMinus8(),
        ConditionalStringFoo(),
        ConditionalStringBar()
      ],
    );
  });
}
