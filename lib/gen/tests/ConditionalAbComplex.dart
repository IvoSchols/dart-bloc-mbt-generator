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
      'emits [ConditionalStringFoo, ConditionalA, ConditionalStringBar, ConditionalStringFoo, ConditionalA, ConditionalStringBar, ConditionalStringFoo, ConditionalA, ConditionalStringBar, ConditionalStringFoo]',
      build: () => conditionalAbComplexCubit,
      act: (cubit) => [
        cubit.goToString("foo"),
        cubit.goToA(),
        cubit.goToString("bar"),
        cubit.goToString("foo"),
        cubit.goToA(),
        cubit.goToString("bar"),
        cubit.goToString("foo"),
        cubit.goToA(),
        cubit.goToString("bar"),
        cubit.goToString("foo")
      ],
      expect: () => [
        ConditionalStringFoo(),
        ConditionalA(),
        ConditionalStringBar(),
        ConditionalStringFoo(),
        ConditionalA(),
        ConditionalStringBar(),
        ConditionalStringFoo(),
        ConditionalA(),
        ConditionalStringBar(),
        ConditionalStringFoo()
      ],
    );
  });
}
