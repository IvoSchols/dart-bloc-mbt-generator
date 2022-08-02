import 'package:bloc_test/bloc_test.dart';
import 'package:dart_bloc_mbt_generator/examples/cubit_examples/simpleAB/cubit/simple_ab_cubit.dart';

import 'package:test/test.dart';

void main() {
  group('SimpleAbCubit', () {
    late SimpleAbCubit simpleAbCubit;

    setUp(() {
      simpleAbCubit = SimpleAbCubit();
    });

    blocTest<SimpleAbCubit, SimpleAbState>(
      'emits SimpleB()',
      build: () => simpleAbCubit,
      act: (cubit) => [cubit.goToB()],
      expect: () => [SimpleB()],
    );

    blocTest<SimpleAbCubit, SimpleAbState>(
      'emits SimpleB(), SimpleA()',
      build: () => simpleAbCubit,
      act: (cubit) => [cubit.goToB(), cubit.goToA()],
      expect: () => [SimpleB(), SimpleA()],
    );
  });
}
