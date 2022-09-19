import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dart_bloc_mbt_generator/examples/cubit_examples/conditional_ab/cubit/conditional_ab_cubit.dart';

void main() {
  group('ConditionalAbCubit', () {
    late ConditionalAbCubit conditionalAbCubit;

    setUp(() {
      conditionalAbCubit = ConditionalAbCubit();
    });

    blocTest<ConditionalAbCubit, ConditionalAbState>(
      'emits [ConditionalBool, ConditionalA, ConditionalBool, ConditionalA, ConditionalBool]',
      build: () => conditionalAbCubit,
      act: (cubit) => [
        cubit.goToBool(true),
        cubit.goToA(),
        cubit.goToBool(true),
        cubit.goToA(),
        cubit.goToBool(true)
      ],
      expect: () => [
        ConditionalBool(),
        ConditionalA(),
        ConditionalBool(),
        ConditionalA(),
        ConditionalBool()
      ],
    );
  });
}
