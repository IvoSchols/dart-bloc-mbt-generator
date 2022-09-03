import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

import '../cubit_examples/simple_ab/cubit/simple_ab_cubit.dart';

void main() {
  group('SimpleAbCubit', () {
    late SimpleAbCubit simpleAbCubit;

    setUp(() {
      simpleAbCubit = SimpleAbCubit();
    });

    blocTest<SimpleAbCubit, SimpleAbState>(
      'emits  SimpleB()() ',
      build: () => simpleAbCubit,
      act: (cubit) => [
        cubit.goToB(),
      ],
      expect: () => [
        SimpleB(),
      ],
    );

    blocTest<SimpleAbCubit, SimpleAbState>(
      'emits  SimpleB()()  SimpleA()() ',
      build: () => simpleAbCubit,
      act: (cubit) => [
        cubit.goToB(),
        cubit.goToA(),
      ],
      expect: () => [
        SimpleB(),
        SimpleA(),
      ],
    );
  });
}
