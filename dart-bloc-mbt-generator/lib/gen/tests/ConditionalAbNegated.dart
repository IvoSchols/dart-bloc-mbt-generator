import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
    import 'package:dart_bloc_mbt_generator/examples/cubit_examples/conditional_ab_negated/cubit/conditional_ab_negated_cubit.dart';
  


void main() {
  group('ConditionalAbNegatedCubit', () {
    late ConditionalAbNegatedCubit conditionalAbNegatedCubit;

    setUp(() {
      conditionalAbNegatedCubit = ConditionalAbNegatedCubit();
    });

    
    blocTest<ConditionalAbNegatedCubit, ConditionalAbNegatedState>(
      'emits [ConditionalB, ConditionalA, ConditionalB, ConditionalA, ConditionalB]',
      build: () => conditionalAbNegatedCubit,
      act: (cubit) => [cubit.goToB(false), cubit.goToA(), cubit.goToB(false), cubit.goToA(), cubit.goToB(false)],
      expect: () => [ConditionalB(), ConditionalA(), ConditionalB(), ConditionalA(), ConditionalB()],
    );
  
  });
}

